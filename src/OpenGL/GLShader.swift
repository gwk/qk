// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation

#if os(OSX)
  import OpenGL
  import OpenGL.GL
  #else
  import OpenGLES
  import OpenGLES.GL
#endif


class GLShader: CustomStringConvertible {
  
  enum Kind: GLenum {
    case vert = 0x8B31 // GL_VERTEX_SHADER
    case frag = 0x8B30 // GL_FRAGMENT_SHADER
    
    static func fromString(_ string: String) -> Kind? {
      switch string {
      case "vert": return .vert
      case "frag": return .frag
      default: return nil
      }
    }
  }
  
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
  let kind: Kind
  let name: String
  let source: String
  
  var description: String { return "GLShader(\(handle): \(name))" }
  
  deinit {
    glDeleteShader(handle)
    glAssert()
  }
  
  func getPar(_ par: GLenum) -> GLint {
    var val: GLint = 0 // returned if error occurs.
    glGetShaderiv(handle, par, &val)
    glAssert()
    return val
  }
  
  var infoLog: String {
    let len = Int(getPar(GLenum(GL_INFO_LOG_LENGTH)))
    var info: [GLchar] = Array(repeating: 0, count: len)
    var lenActual: GLsizei = 0
    glGetShaderInfoLog(handle, GLsizei(len), &lenActual, &info)
    glAssert()
    return String(validatingUTF8:info)!
  }
  
  init(kind: Kind, name: String, sources: [String]) {
    self.handle = glCreateShader(kind.rawValue)
    glAssert()
    self.kind = kind
    self.name = name
    self.source = String(lines: GLShader.prefixLines + sources)
    glProvideShaderSource(handle, source: source)
    glAssert()
    glCompileShader(handle)
    glAssert()
    check(getPar(GLenum(GL_COMPILE_STATUS)) == GL_TRUE,
      "shader compile failed: \(name)\n\(infoLog)source:\n\(String(lines: source.numberedLines))\n")
  }
  
  class func withResources(_ resources: [String]) throws -> GLShader {
    let ext = NSString(string: resources.last!).pathExtension // TODO: implement pathExtension on String.
    let sources = try resources.map() {
      (name: String) throws -> String in
      let e = NSString(string: name).pathExtension as String // TODO: implement pathExtension on String.
      assert(e == ext, "mismatched shader name extension: \(name)")
      return try Bundle.textNamed(name)
    }
    let kind = Kind.fromString(ext)!
    return GLShader(kind: kind, name: resources.last!, sources: sources)
  }
}
