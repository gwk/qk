// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


#if os(iOS)
let GLShader_prefix = ""
  #else
    // ignore GLSL ES precision specifiers.
let GLShader_prefix = String(lines:
  "#define lowp",
  "#define mediump",
  "#define highp",
  "")
#endif



class GLShader: Printable {
  let handle: GLHandle
  let type: GLenum
  let name: String
  let source: String
  
  var description: String { return "GLShader(\(handle): \(name))" }
  
  deinit {
    glDeleteShader(handle)
    glAssert()
  }
  
  var prefixLineCount: Int { return GLShader_prefix.lineCount }

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
    self.source = GLShader_prefix + String(lines: sources)
    glShaderSource1(handle, source, Int32(source.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
    glAssert()
    glCompileShader(handle)
    glAssert()
    check(getPar(GLenum(GL_COMPILE_STATUS)) == GL_TRUE,
      "shader compile failed: \(name)\n\(infoLog)source:\n\(String(lines: source.numberedLines))\n")
  }
  
  class func res(res: [String]) -> GLShader {
    let ext0 = res[0].pathExtension
    let sources = res.map() {
      (name: String) -> String in
      let ext = name.pathExtension
      assert(ext == ext0, "mismatched shader name extension: \(name)")
      return NSBundle.textNamed(name)
    }
    var type: GLenum
    switch ext0 {
    case "vert": type = GLenum(GL_VERTEX_SHADER)
    case "frag": type = GLenum(GL_FRAGMENT_SHADER)
    default: fatalError("bad shader name extension: \(res[0])")
    }
    return GLShader(type: type, name: res.last!, sources: sources)
  }
}
