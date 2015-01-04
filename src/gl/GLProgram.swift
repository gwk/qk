// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


enum GLInputType: GLenum, Printable {
  case F = 0x1406 // GL_FLOAT
  case V2 = 0x8B50 // GL_FLOAT_VEC2
  case V3 = 0x8B51 // GL_FLOAT_VEC3
  case V4 = 0x8B52 // GL_FLOAT_VEC4
  case I = 0x1404 // GL_INT
  case S2 = 0x8B5E // GL_SAMPLER_2D
  //GL_INT_VEC2
  //GL_INT_VEC3
  //GL_INT_VEC4
  //GL_BOOL, GL_BOOL_VEC2, GL_BOOL_VEC3, GL_BOOL_VEC4
  //GL_FLOAT_MAT2, GL_FLOAT_MAT3, GL_FLOAT_MAT4
  //GL_SAMPLER_CUBE
  
  var description: String {
    switch self {
    case F: return "F"
    case V2: return "V2"
    case V3: return "V3"
    case V4: return "V4"
    case I: return "I"
    case S2: return "S2"
    }
  }
  
  var compType: GLenum {
    switch self {
    case F, V2, V3, V4: return GLenum(GL_FLOAT)
    case I: return GLenum(GL_INT)
    default: fatalError("no comp type for GLInputType: \(self)")
    }
  }
}

struct GLInput: Printable {
  let name: String
  let isAttr: Bool
  let loc: GLint
  let type: GLInputType
  let size: Int
  var description: String { return "GLVarInfo(name:\(name), isAttr:\(isAttr), loc:\(loc), type:\(type), size:\(size))" }
}

class GLProgram {
  let handle: GLHandle
  let shaders: [GLShader]
  var inputs: [String : GLInput] = [:]
  
  deinit {
    glDeleteProgram(handle)
    glAssert()
  }
  
  func getPar(par: GLenum) -> GLint {
    var val: GLint = 0 // returned if error occurs
    glGetProgramiv(handle, par, &val)
    glAssert()
    return val
  }
  
  var infoLog: String {
    let len = Int(getPar(GLenum(GL_INFO_LOG_LENGTH)))
    var info = [GLchar](count: len, repeatedValue: 0)
    var lenActual: GLsizei = 0
    glGetProgramInfoLog(handle, GLsizei(len), &lenActual, &info)
    glAssert()
    return String(UTF8String:info)!
  }
  
  class func maxVertexAttributes() -> Int {
    var val: GLint = 0
    glGetIntegerv(GLenum(GL_MAX_VERTEX_ATTRIBS), &val)
    return Int(val)
  }

  func addInput(name: String, isAttr: Bool, loc: GLint, type: GLenum, size: GLsizei) {
    assert(loc != -1,"no location for shader input: \(name)")
    let inputType = GLInputType(rawValue: type)
    assert(inputType != nil, "bad input type: 0x\(Int(type).h)")
    let info = GLInput(name: name, isAttr: isAttr, loc: loc, type: inputType!, size: Int(size))
    let label = isAttr ? "attr" : "uniform"
    println("  \(label): \(name): \(info)")
    inputs[name] = info
  }
  
  init(shaders: [GLShader]) {
    handle = glCreateProgram()
    glAssert()
    println("GLProgram(\(handle): \(shaders))")
    self.shaders = shaders
    for s in shaders {
      glAttachShader(handle, s.handle)
      glAssert()
    }
    glLinkProgram(handle)
    glAssert()
    check(getPar(GLenum(GL_LINK_STATUS)) == GL_TRUE, "GLProgram link failed: \(infoLog)")    
    #if DEBUG
      glValidateProgram(handle)
      glAssert()
      check(getPar(handle, GLenum(GL_VALIDATE_STATUS)), "GLProgram validation failed: \(infoLog)")
      check(attributes.count <= maxVertexAttributes(),
        "too many vertex attributes (max \(maxVertexAttributes())): \(attributes.count)")
    #endif
    
    var uniformCount: GLint = -1
    glGetProgramiv(handle, GLenum(GL_ACTIVE_UNIFORMS), &uniformCount)
    glAssert()
    var attrCount: GLint = -1
    glGetProgramiv(handle, GLenum(GL_ACTIVE_ATTRIBUTES), &attrCount)
    glAssert()
    var nameBuffer = Array<GLchar>(count: 256, repeatedValue: 0)
    
    for i in 0..<GLuint(uniformCount) {
      var count = GLsizei(-1)
      var size = GLsizei(-1)
      var type = GLenum(0)
      glGetActiveUniform(handle, i, GLsizei(nameBuffer.count), &count, &size, &type, &nameBuffer)
      glAssert()
      let name = String(UTF8String: nameBuffer)!
      let loc = glGetUniformLocation(handle, name)
      glAssert()
      addInput(name, isAttr: false, loc: loc, type: type, size: size)
    }
    for i in 0..<GLuint(attrCount) {
      var count = GLsizei(-1)
      var size = GLsizei(-1)
      var type = GLenum(0)
      glGetActiveAttrib(handle, i, GLsizei(nameBuffer.count), &count, &size, &type, &nameBuffer)
      glAssert()
      let name = String(UTF8String: nameBuffer)!
      let loc = glGetAttribLocation(handle, name)
      glAssert()
      addInput(name, isAttr: true, loc: loc, type: type, size: size)
    }
  }
  
  convenience init(_ shaders: GLShader...) { self.init(shaders: shaders) }
  
  func inputLoc(name: String, isAttr: Bool, type: GLInputType, size: Int) -> GLint {
    // GLSL will optimize out unused uniforms/attrs, which is annyoing during development and debugging.
    // to mitigate this, unrecognized uniforms/attrs will get the special -1 location when first queried;
    // print error once then subsequently ignore.
    if let info = inputs[name] {
      assert(info.isAttr == isAttr)
      assert(info.type == type)
      assert(info.size == size)
      return info.loc
    } else {
      println("NOTE: no input for name: \(name)")
      inputs[name] = GLInput(name: name, isAttr: isAttr, loc: -1, type: type, size: size)
      return -1
    }
  }
  
  func use() {
    glUseProgram(handle)
    glAssert()
    for (name, input) in inputs {
      if input.isAttr && input.loc != -1 {
        glEnableVertexAttribArray(GLuint(input.loc))
        glAssert()
      }
    }
  }
  
  func bindUniform(name: String, f: F32) {
    let loc = inputLoc(name, isAttr: false, type: .F, size: 1)
    if loc == -1 { return }
    glUniform1f(loc, f)
    glAssert()
  }
  
  func bindUniform(name: String, v2: V2F32) {
    let loc = inputLoc(name, isAttr: false, type: .V2, size: 1)
    if loc == -1 { return }
    glUniform2f(loc, v2.x, v2.y)
    glAssert()
  }

  func bindUniform(name: String, v3: V3F32) {
    let loc = inputLoc(name, isAttr: false, type: .V3, size: 1)
    if loc == -1 { return }
    glUniform3f(loc, v3.x, v3.y, v3.z)
    glAssert()
  }
  
  func bindUniform(name: String, v4: V4F32) {
    let loc = inputLoc(name, isAttr: false, type: .V4, size: 1)
    if loc == -1 { return }
    glUniform4f(loc, v4.x, v4.y, v4.z, v4.w)
    glAssert()
  }
  
  func bindUniform(name: String, i: Int) {
    let loc = inputLoc(name, isAttr: false, type: .I, size: 1)
    if loc == -1 { return }
    glUniform1i(loc, GLint(i))
    glAssert()
  }
  
  func bindUniform(name: String, tex: GLTexture, unit: Int) {
    let loc = inputLoc(name, isAttr: false, type: .S2, size: 1)
    if loc == -1 { return }
    // NOTE: this addition assumes that the unit enums are consecutive.
    glActiveTexture(GLenum(GL_TEXTURE0 + unit))
    glAssert()
    tex.bind()
    glUniform1i(loc, GLint(unit))
    glAssert()
  }
  
  func bindAttr(name: String, size: Int, type: GLInputType, normalize: Bool, stride: Int, ptr: UnsafePointer<Void>) {
    let loc = inputLoc(name, isAttr: true, type: type, size: 1)
    if loc == -1 { return } // known missing name.
    let n = GLboolean(normalize ? GL_TRUE : GL_FALSE)
    glVertexAttribPointer(GLuint(loc), GLint(size), type.compType, n, GLsizei(stride), ptr)
    glAssert()
  }
  
  func bindAttr(name: String, stride: Int, F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 1, type: .F, normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(name: String, stride: Int, V2F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 2, type: .V2, normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(name: String, stride: Int, V3F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 3, type: .V3, normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(name: String, stride: Int, V4F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 4, type: .V4, normalize: false, stride: stride, ptr: p + offset)
  }
  
}

