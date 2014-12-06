// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


var GL_maxTextureSize: Int = 0

class GLTexture {

  let handle: GLHandle
  let target: GLenum // e.g. GL_TEXTURE_2D.
  let format: GLenum // i.e. GL_ALPHA, GL_LUMINANCE, GL_LUMINANCE_ALPHA, GL_RGB, GL_RGBA.
  let w: Int
  let h: Int

  
  deinit {
    glDeleteTexture(handle)
    glAssert()
  }
  
  init(format: GLenum, w: Int, h: Int, dataFormat: GLenum, dataType: GLenum, bytes: UnsafePointer<U8>) {
    // check texture size
    if GL_maxTextureSize == 0 {
      var s: GLint = 0
      glGetIntegerv(GLenum(GL_MAX_TEXTURE_SIZE), &s); // should be at least 2048.
      glAssert()
      GL_maxTextureSize = Int(s)
      println("GLTexture maxTextureSize: \(GL_maxTextureSize)")
    }
    check(w <= GL_maxTextureSize && h <= GL_maxTextureSize,
      "GLTexture exceeds maxTextureSize (\(GL_maxTextureSize)): w: \(w); h: \(h)")
    handle = 0
    glGenTextures(1, &handle)
    glAssert()
    self.target = GLenum(GL_TEXTURE_2D) // ES also supports GL_CUBE_MAP.
    self.format = format
    self.w = w
    self.h = h
    glBindTexture(target, handle)
    glAssert()
    //func glTexImage2D(target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, height: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: UnsafePointer<Void>)
    glTexImage2D(target, 0, GLint(format), GLsizei(w), GLsizei(h), 0, dataFormat, dataType, bytes)
    glAssert()
    // set default wrap and filter for convenience.
    // forgetting to set the filter appears to result in undefined behavior? (black samples).
    setWrap(GLenum(GL_CLAMP_TO_EDGE)) // friendlier for debugging, as it allows vertices to range from 0 to 1.
    setFilter(GLenum(GL_LINEAR)) // choose smooth results over performance as default.
  }
    
  func setMinFilter(filter: GLenum) {
    bindToTarget() // does texture need to be bound when this is called?
    assert(
      filter == GLenum(GL_NEAREST) ||
      filter == GLenum(GL_LINEAR) ||
      filter == GLenum(GL_NEAREST_MIPMAP_NEAREST) ||
      filter == GLenum(GL_LINEAR_MIPMAP_NEAREST) ||
      filter == GLenum(GL_NEAREST_MIPMAP_LINEAR) ||
      filter == GLenum(GL_LINEAR_MIPMAP_LINEAR),
      "bad texture filter parameter: \(filter)")
    glTexParameteri(target, GLenum(GL_TEXTURE_MIN_FILTER), GLint(filter));
    glAssert()
  }
  
  func setMagFilter(filter: GLenum) {
    bindToTarget() // does texture need to be bound when this is called?
    assert(filter == GLenum(GL_NEAREST) || filter == GLenum(GL_LINEAR),
      "bad texture filter parameter: \(filter)")
    glTexParameteri(target, GLenum(GL_TEXTURE_MAG_FILTER), GLint(filter))
    glAssert()
  }
  
  func setFilter(filter: GLenum) {
    setMinFilter(filter)
    let mag_filter = (filter == GLenum(GL_NEAREST) || filter == GLenum(GL_NEAREST_MIPMAP_NEAREST))
    ? GLenum(GL_NEAREST) : GLenum(GL_LINEAR)
    setMagFilter(mag_filter)
  }
  
  func setWrap(wrap: GLenum, axis: GLenum) {
    bindToTarget() // does texture need to be bound when this is called?
    assert(wrap == GLenum(GL_CLAMP_TO_EDGE) || wrap == GLenum(GL_MIRRORED_REPEAT) || wrap == GLenum(GL_REPEAT),
      "bad texture wrap parameter: \(wrap)")
    glTexParameteri(target, axis, GLint(wrap))
    glAssert()
    glTexParameteri(target, axis, GLint(wrap))
    glAssert()
  }
  
  func setWrap(wrap: GLenum) {
    setWrap(wrap, axis: GLenum(GL_TEXTURE_WRAP_S))
    setWrap(wrap, axis: GLenum(GL_TEXTURE_WRAP_T))
  }
  
  func bindToTarget() {
    //glEnable(_target); qkgl_assert(); // necessary in OpenGL? invalid in ES2.
    glBindTexture(target, handle)
    glAssert()
  }
  
  func unbindFromTarget() {
    // TODO: should this be a class function?
    //glEnable(_target); qkgl_assert(); // necessary in OpenGL? invalid in ES2.
    glBindTexture(target, 0)
    glAssert()
  }
}  
