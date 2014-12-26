// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


var GLTexture_maxSize: Int = 0

func GLTexture_getMaxSize() -> Int {
    if GLTexture_maxSize == 0 {
      var s: GLint = 0
      glGetIntegerv(GLenum(GL_MAX_TEXTURE_SIZE), &s); // should be at least 2048.
      glAssert()
      GLTexture_maxSize = Int(s)
      assert(GLTexture_maxSize > 0, "GLTexture_maxSize is zero; called before GL context is active?")
      println("GLTexture maxSize: \(GLTexture_maxSize)")
    }
  return GLTexture_maxSize
}


class GLTexture {
  let handle: GLHandle
  var target: GLenum = GLenum(0) // e.g. GL_TEXTURE_2D.
  var format: GLenum = GLenum(0) // i.e. GL_ALPHA, GL_LUMINANCE, GL_LUMINANCE_ALPHA, GL_RGB, GL_RGBA.
  var w: Int = 0
  var h: Int = 0
  
  deinit {
    glDeleteTexture(handle)
    glAssert()
  }
  
  init(target: GLenum = GLenum(GL_TEXTURE_2D)) {
    self.target = target // ES also supports GL_CUBE_MAP.
    var h: GLHandle = 0
    glGenTextures(1, &h)
    glAssert()
    handle = h
  }
  
  convenience init(target: GLenum = GLenum(GL_TEXTURE_2D), w: Int, h: Int, format: GLenum, dataFormat: GLenum, dataType: GLenum, data: UnsafePointer<U8>) {
    self.init(target: target)
    update(w, h, format: format, dataFormat: dataFormat, dataType: dataType, data: data)
  }
  
  func update(w: Int, _ h: Int, format: GLenum, dataFormat: GLenum, dataType: GLenum, data: UnsafePointer<Void>) {
    let maxSize = GLTexture_getMaxSize()
    check(w <= maxSize && h <= maxSize, "GLTexture exceeds maxSize (\(maxSize)): w: \(w); h: \(h)")
    self.w = w
    self.h = h
    self.format = format
    glBindTexture(target, handle)
    glAssert()
    //func glTexImage2D(target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, height: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: UnsafePointer<Void>)
    glTexImage2D(target, 0, GLint(format), GLsizei(w), GLsizei(h), 0, dataFormat, dataType, data)
    glAssert()
    // set default wrap and filter for convenience.
    // forgetting to set the filter appears to result in undefined behavior? (black samples).
    setWrap(GLenum(GL_CLAMP_TO_EDGE)) // friendlier for debugging, as it allows vertices to range from 0 to 1.
    setFilter(GLenum(GL_LINEAR)) // choose smooth results over performance as default.
  }
    
  func setMinFilter(filter: GLenum) {
    bind() // does texture need to be bound when this is called?
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
    bind() // does texture need to be bound when this is called?
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
    bind() // does texture need to be bound when this is called?
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
  
  func bind() {
    //glEnable(_target); qkgl_assert(); // TODO: necessary in OpenGL? invalid in ES2.
    glBindTexture(target, handle)
    glAssert()
  }
  
  func unbind() {
    // TODO: should this be a class function?
    //glEnable(_target); qkgl_assert(); // TODO: necessary in OpenGL? invalid in ES2.
    glBindTexture(target, 0)
    glAssert()
  }
}  
