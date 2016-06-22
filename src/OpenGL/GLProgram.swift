// © 2014 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import OpenGL
  #else
  import OpenGLES
#endif


enum GLInputType: GLenum, CustomStringConvertible {
  case f = 0x1406 // GL_FLOAT
  case v2 = 0x8B50 // GL_FLOAT_VEC2
  case v3 = 0x8B51 // GL_FLOAT_VEC3
  case v4 = 0x8B52 // GL_FLOAT_VEC4
  case i = 0x1404 // GL_INT
  case sampler2 = 0x8B5E // GL_SAMPLER_2D
  //GL_INT_VEC2
  //GL_INT_VEC3
  //GL_INT_VEC4
  //GL_BOOL, GL_BOOL_VEC2, GL_BOOL_VEC3, GL_BOOL_VEC4
  //GL_FLOAT_MAT2, GL_FLOAT_MAT3, GL_FLOAT_MAT4
  //GL_SAMPLER_CUBE
  
  var description: String {
    switch self {
    case f: return "F"
    case v2: return "V2"
    case v3: return "V3"
    case v4: return "V4"
    case i: return "I"
    case sampler2: return "Sampler2"
    }
  }
  
  var compType: GLenum {
    switch self {
    case f, v2, v3, v4: return GLenum(GL_FLOAT)
    case i: return GLenum(GL_INT)
    default: fatalError("no comp type for GLInputType: \(self)")
    }
  }
}


struct GLInput: CustomStringConvertible {
  let name: String
  let isAttr: Bool
  let loc: GLint
  let type: GLInputType
  let size: Int
  var description: String { return "GLVarInfo(name:\(name), isAttr:\(isAttr), loc:\(loc), type:\(type), size:\(size))" }
}


class GLProgram {
  let handle: GLHandle
  var shaders: [GLShader] = []
  var inputs: [String : GLInput] = [:]
  
  deinit {
    glDeleteProgram(handle)
    glAssert()
  }
  
  func getPar(_ par: GLenum) -> GLint {
    var val: GLint = 0 // returned if error occurs
    glGetProgramiv(handle, par, &val)
    glAssert()
    return val
  }
  
  var infoLog: String {
    let len = Int(getPar(GLenum(GL_INFO_LOG_LENGTH)))
    var info = [GLchar](repeating: 0, count: len)
    var lenActual: GLsizei = 0
    glGetProgramInfoLog(handle, GLsizei(len), &lenActual, &info)
    glAssert()
    return String(validatingUTF8:info)!
  }
  
  class func maxVertexAttributes() -> Int {
    var val: GLint = 0
    glGetIntegerv(GLenum(GL_MAX_VERTEX_ATTRIBS), &val)
    return Int(val)
  }

  func addInput(_ name: String, isAttr: Bool, loc: GLint, type: GLenum, size: GLsizei) {
    assert(loc != -1,"no location for shader input: \(name)")
    let inputType = GLInputType(rawValue: type)
    assert(inputType != nil, "bad input type: 0x\(Int(type).hex)")
    let info = GLInput(name: name, isAttr: isAttr, loc: loc, type: inputType!, size: Int(size))
    //let label = isAttr ? "attr" : "uniform"
    //println("  \(label): \(name): \(info)")
    inputs[name] = info
  }
  
  
  func link(_ shaders: [GLShader]) {
    // detach old shaders.
    for s in self.shaders {
      glDetachShader(handle, s.handle)
      glAssert()
    }
    inputs.removeAll()
    // attach new shaders.
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
    var nameBuffer = Array<GLchar>(repeating: 0, count: 256)
    
    for i in 0..<GLuint(uniformCount) {
      var count = GLsizei(-1)
      var size = GLsizei(-1)
      var type = GLenum(0)
      glGetActiveUniform(handle, i, GLsizei(nameBuffer.count), &count, &size, &type, &nameBuffer)
      glAssert()
      let name = String(validatingUTF8: nameBuffer)!
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
      let name = String(validatingUTF8: nameBuffer)!
      let loc = glGetAttribLocation(handle, name)
      glAssert()
      addInput(name, isAttr: true, loc: loc, type: type, size: size)
    }
    //println("GLProgram(\(handle): \(shaders))")
  }
  
  init() {
    handle = glCreateProgram()
    glAssert()
  }
  
  convenience init(shaders: [GLShader]) {
    self.init()
    self.link(shaders)
  }
  
  convenience init(_ shaders: GLShader...) { self.init(shaders: shaders) }
  
  convenience init(name: String, sources: [String]) {
    // init from a single composite source file; the convention here is to use the extension '.shdr'.
    // this file consists of three parts:
    // <lines common to both vertex and fragment shaders>
    // vert:
    // <lines for vertex shader>
    // frag:
    // <lines for fragment shader>
    self.init()
    let source = String(lines: sources)
    func error(_ msg: String) {
      let lines = String(lines: source.numberedLines)
      fatalError("GLProgram: invalid composite .shdr file: \(msg)\nsource:\n\(lines)\n")
    }
    if let (common, specifics) = source.part("\nvert:\n") {
      if let (vert, frag) = specifics.part("\nfrag:\n") {
        let v = GLShader(kind: .vert, name: name + ":vert", sources: [common, vert])
        let f = GLShader(kind: .frag, name: name + ":frag", sources: [common, frag])
        self.link([v, f])
      } else {
        error("missing '\\nfrag:\\n' separator line")
      }
    } else {
      error("missing '\\nvert:\\n' separator line")
    }
  }
  
  
  func inputLoc(_ name: String, isAttr: Bool, type: GLInputType, size: Int) -> GLint {
    // GLSL will optimize out unused uniforms/attrs, which is annyoing during development and debugging.
    // to mitigate this, unrecognized uniforms/attrs will get the special -1 location when first queried;
    // print error once then subsequently ignore.
    if let info = inputs[name] {
      assert(info.isAttr == isAttr)
      assert(info.type == type)
      assert(info.size == size)
      return info.loc
    } else {
      print("NOTE: no input for name: \(name)")
      inputs[name] = GLInput(name: name, isAttr: isAttr, loc: -1, type: type, size: size)
      return -1
    }
  }
  
  func use() {
    glUseProgram(handle)
    glAssert()
    for (_, input) in inputs {
      if input.isAttr && input.loc != -1 {
        glEnableVertexAttribArray(GLuint(input.loc))
        glAssert()
      }
    }
  }
  
  func bindUniform(_ name: String, f: F32) {
    let loc = inputLoc(name, isAttr: false, type: .f, size: 1)
    if loc == -1 { return }
    glUniform1f(loc, f)
    glAssert()
  }
  
  func bindUniform(_ name: String, v2: V2S) {
    let loc = inputLoc(name, isAttr: false, type: .v2, size: 1)
    if loc == -1 { return }
    glUniform2f(loc, v2.x, v2.y)
    glAssert()
  }

  func bindUniform(_ name: String, v3: V3S) {
    let loc = inputLoc(name, isAttr: false, type: .v3, size: 1)
    if loc == -1 { return }
    glUniform3f(loc, v3.x, v3.y, v3.z)
    glAssert()
  }
  
  func bindUniform(_ name: String, v4: V4S) {
    let loc = inputLoc(name, isAttr: false, type: .v4, size: 1)
    if loc == -1 { return }
    glUniform4f(loc, v4.x, v4.y, v4.z, v4.w)
    glAssert()
  }
  
  func bindUniform(_ name: String, i: Int) {
    let loc = inputLoc(name, isAttr: false, type: .i, size: 1)
    if loc == -1 { return }
    glUniform1i(loc, GLint(i))
    glAssert()
  }
  
  func bindUniform(_ name: String, tex: GLTexture, unit: Int) {
    let loc = inputLoc(name, isAttr: false, type: .sampler2, size: 1)
    if loc == -1 { return }
    // NOTE: this addition assumes that the unit enums are consecutive.
    glActiveTexture(GLenum(GL_TEXTURE0 + unit))
    glAssert()
    tex.bind()
    glUniform1i(loc, GLint(unit))
    glAssert()
  }
  
  func bindAttr(_ name: String, size: Int, type: GLInputType, normalize: Bool, stride: Int, ptr: UnsafePointer<Void>) {
    let loc = inputLoc(name, isAttr: true, type: type, size: 1)
    if loc == -1 { return } // known missing name.
    let n = GLboolean(normalize ? GL_TRUE : GL_FALSE)
    glVertexAttribPointer(GLuint(loc), GLint(size), type.compType, n, GLsizei(stride), ptr)
    glAssert()
  }
  
  func bindAttr(_ name: String, stride: Int, F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 1, type: .f, normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(_ name: String, stride: Int, V2S p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 2, type: .v2, normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(_ name: String, stride: Int, V3S p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 3, type: .v3, normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(_ name: String, stride: Int, V4S p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 4, type: .v4, normalize: false, stride: stride, ptr: p + offset)
  }
  
}

