// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


class GLProgram {
  let handle: GLHandle
  let shaders: [GLShader]
  let uniforms: [String]
  let attrs: [String]
  var uniformLocs: [String : GLint] = [:]
  var attrLocs: [String : GLint] = [:]
  
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

  init(shaders: [GLShader], uniforms: [String], attrs: [String]) {
    handle = glCreateProgram()
    glAssert()
    self.shaders = shaders
    self.uniforms = uniforms
    self.attrs = attrs
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
    // GLSL will optimize out unused uniforms/attributes, which is annyoing during development and debugging.
    // to mitigate this, we print a note when names are missing, rather than throw an error.
    uniformLocs = uniforms.mapToDict() {
      (name: String) in
      let loc = glGetUniformLocation(self.handle, name)
      if loc == -1 {
        println("NOTE: no location for shader uniform: \(name)")
      }
      return (name, loc)
    }
    attrLocs = attrs.mapToDict() {
      (name: String) in
      let loc = glGetAttribLocation(self.handle, name)
      if loc == -1 {
        println("NOTE: no location for shader attribute: \(name)")
      }
      return (name, loc)
    }
  }
  
  func locForAttr(name: String) -> GLint {
    return attrLocs[name]!
  }
  
  func locForUniform(name: String) -> GLint {
    return uniformLocs[name]!
  }
  
  func use() {
    glUseProgram(handle)
    glAssert()
    for (name, loc) in attrLocs {
      if loc != -1 {
        glEnableVertexAttribArray(GLuint(loc))
        glAssert()
      }
    }
  }
  
  func bindUniform(name: String, f: F32) {
    let loc = locForUniform(name)
    if loc == -1 { return } // known missing name.
    glUniform1f(loc, f)
    glAssert()
  }
  
  func bindUniform(name: String, v2: V2F32) {
    let loc = locForUniform(name)
    if loc == -1 { return } // known missing name.
    glUniform2f(loc, v2.x, v2.y)
    glAssert()
  }

  func bindUniform(name: String, v3: V3F32) {
    let loc = locForUniform(name)
    if loc == -1 { return } // known missing name.
    glUniform3f(loc, v3.x, v3.y, v3.z)
    glAssert()
  }
  
  func bindUniform(name: String, v4: V4F32) {
    let loc = locForUniform(name)
    if loc == -1 { return } // known missing name.
    glUniform4f(loc, v4.x, v4.y, v4.z, v4.w)
    glAssert()
  }
  
  func bindUniform(name: String, i: Int) {
    let loc = locForUniform(name)
    if loc == -1 { return } // known missing name.
    glUniform1i(loc, GLint(i))
    glAssert()
  }
  
  func bindUniform(name: String, tex: GLTexture, unit: Int) {
    let loc = locForUniform(name)
    // NOTE: this addition assumes that the unit enums are consecutive.
    glActiveTexture(GLenum(GL_TEXTURE0 + unit))
    glAssert()
    tex.bind()
    bindUniform(name, i: unit)
  }

  func bindAttr(name: String, size: Int, type: GLenum, normalize: Bool, stride: Int, ptr: UnsafePointer<Void>) {
    let loc = locForAttr(name)
    if loc == -1 { return } // known missing name.
    let n = normalize ? GLboolean(GL_TRUE) : GLboolean(GL_FALSE)
    glVertexAttribPointer(GLuint(loc), GLint(size), type, n, GLsizei(stride), ptr)
    glAssert()
  }
  
  func bindAttr(name: String, stride: Int, F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 1, type: GLenum(GL_FLOAT), normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(name: String, stride: Int, V2F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 2, type: GLenum(GL_FLOAT), normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(name: String, stride: Int, V3F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 3, type: GLenum(GL_FLOAT), normalize: false, stride: stride, ptr: p + offset)
  }
  
  func bindAttr(name: String, stride: Int, V4F32 p: UnsafePointer<Void>, offset: Int) {
    bindAttr(name, size: 4, type: GLenum(GL_FLOAT), normalize: false, stride: stride, ptr: p + offset)
  }
  
}

