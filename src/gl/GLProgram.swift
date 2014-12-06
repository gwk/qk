// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


class GLProgram {
  let handle: GLHandle
  let shaders: [GLShader]
  let uniforms: [String]
  let attrs: [String]
  var uniformLocs: [String : GLint]!
  var attrLocs: [String : GLint]!
  
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
}
