// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation

#if os(OSX)
  import OpenGL
  import OpenGL.GL
  #else
  import OpenGLES
  import OpenGLES.GL
#endif


class GLShader: Printable {
  
  #if os(OSX)
  // ignore GLSL ES precision specifiers.
  static let prefixLines = [
    // "#version 150 core", SCNView does not support this?
    "#define lowp",
    "#define mediump",
    "#define highp",
    ""]
  #else
  let prefixlines = []
  #endif
  
  let handle: GLHandle
  let type: GLenum
  let name: String
  let source: String
  
  var description: String { return "GLShader(\(handle): \(name))" }
  
  deinit {
    glDeleteShader(handle)
    glAssert()
  }
  
  func getPar(par: GLenum) -> GLint {
    var val: GLint = 0 // returned if error occurs.
    glGetShaderiv(handle, par, &val)
    glAssert()
    return val
  }
  
  var infoLog: String {
    let len = Int(getPar(GLenum(GL_INFO_LOG_LENGTH)))
    var info: [GLchar] = Array(count: len, repeatedValue: 0)
    var lenActual: GLsizei = 0
    glGetShaderInfoLog(handle, GLsizei(len), &lenActual, &info)
    glAssert()
    return String(UTF8String:info)!
  }
  
  init(type: GLenum, name: String, sources: [String]) {
    self.handle = glCreateShader(type)
    glAssert()
    self.type = type
    self.name = name
    self.source = String(lines: GLShader.prefixLines + sources)
    glProvideShaderSource(handle, source)
    glAssert()
    glCompileShader(handle)
    glAssert()
    check(getPar(GLenum(GL_COMPILE_STATUS)) == GL_TRUE,
      "shader compile failed: \(name)\n\(infoLog)source:\n\(String(lines: source.numberedLines))\n")
  }
  
  class func withResources(resources: [String]) -> GLShader {
    let ext0 = resources[0].pathExtension
    let sources = resources.map() {
      (name: String) -> String in
      let ext = name.pathExtension
      assert(ext == ext0, "mismatched shader name extension: \(name)")
      return NSBundle.textNamed(name)
    }
    var type: GLenum
    switch ext0 {
    case "vert": type = GLenum(GL_VERTEX_SHADER)
    case "frag": type = GLenum(GL_FRAGMENT_SHADER)
    default: fatalError("bad shader name extension: \(resources[0])")
    }
    return GLShader(type: type, name: resources.last!, sources: sources)
  }
}
