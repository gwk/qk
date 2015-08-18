// © 2014 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import OpenGL
  import OpenGL.GL
  #else
  import OpenGLES
  import OpenGLES.GL
#endif


var GLTexture_maxSize: I32 = 0

func GLTexture_getMaxSize() -> I32 {
  // note: this is an explicit function because it must be called while the gl context is active.
    if GLTexture_maxSize == 0 {
      var s: GLint = 0
      glGetIntegerv(GLenum(GL_MAX_TEXTURE_SIZE), &s); // should be at least 2048.
      glAssert()
      GLTexture_maxSize = I32(s)
      assert(GLTexture_maxSize > 0, "GLTexture_maxSize is zero; called before GL context is active?")
      //println("GLTexture maxSize: \(GLTexture_maxSize)")
    }
  return GLTexture_maxSize
}


enum GLTexTarget: GLenum {
  #if os(OSX)
  case Rect = 0x0DE1 // GL_TEXTURE_2D.
  case CubeMap = 0x8513 // GL_TEXTURE_CUBE_MAP.
  #else
  #endif
}

enum GLTexFmt: GLenum {
  #if os(OSX)
  case A = 0x1906     // GL_ALPHA.
  case L = 0x1903     // GL_RED; GL_LUMINANCE is deprecated.
  case LA = 0x190A    // GL_RG; GL_LUMINANCE_ALPHA is deprecated.
  case RGB = 0x1907   // GL_RGB.
  case RGBA = 0x1908  // GL_RGBA.
  #else
  #endif
}

enum GLDataType: GLenum {
  #if os(OSX)
  case U8 = 0x1401 // GL_UNSIGNED_BYTE.
  #else
  #endif
}

class GLTexture {
  let handle: GLHandle
  var target: GLTexTarget
  var fmt: GLTexFmt = .RGBA
  var w: Int = 0
  var h: Int = 0
  
  deinit {
    glDeleteTextureHandles(handle)
    glAssert()
  }
  
  init(target: GLTexTarget = .Rect) {
    self.target = target
    var _handle: GLHandle = 0
    glGenTextures(1, &_handle)
    glAssert()
    handle = _handle
  }
  
  convenience init(target: GLTexTarget = .Rect, w: Int, h: Int, fmt: GLTexFmt, dataFmt: GLTexFmt, dataType: GLDataType,
    data: UnsafePointer<Void>) {
      self.init(target: target)
      update(w: w, h: h, fmt: fmt, dataFmt: dataFmt, dataType: dataType, data: data)
  }
  
  func update(w w: Int, h: Int, fmt: GLTexFmt, dataFmt: GLTexFmt, dataType: GLDataType, data: UnsafePointer<Void>) {
    GLTexture_getMaxSize()
    //check(w <= maxSize && h <= maxSize, "GLTexture exceeds maxSize (\(maxSize)): w: \(w); h: \(h)")
    self.w = w
    self.h = h
    self.fmt = fmt
    glBindTexture(target.rawValue, handle)
    glAssert()
    glTexImage2D(target.rawValue, 0, GLint(fmt.rawValue), GLsizei(w), GLsizei(h), 0, dataFmt.rawValue, dataType.rawValue, data)
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
    glTexParameteri(target.rawValue, GLenum(GL_TEXTURE_MIN_FILTER), GLint(filter));
    glAssert()
  }
  
  func setMagFilter(filter: GLenum) {
    bind() // does texture need to be bound when this is called?
    assert(filter == GLenum(GL_NEAREST) || filter == GLenum(GL_LINEAR),
      "bad texture filter parameter: \(filter)")
    glTexParameteri(target.rawValue, GLenum(GL_TEXTURE_MAG_FILTER), GLint(filter))
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
    glTexParameteri(target.rawValue, axis, GLint(wrap))
    glAssert()
    glTexParameteri(target.rawValue, axis, GLint(wrap))
    glAssert()
  }
  
  func setWrap(wrap: GLenum) {
    setWrap(wrap, axis: GLenum(GL_TEXTURE_WRAP_S))
    setWrap(wrap, axis: GLenum(GL_TEXTURE_WRAP_T))
  }
  
  func bind() {
    //glEnable(_target); qkgl_assert(); // TODO: necessary in OpenGL? invalid in ES2.
    glBindTexture(target.rawValue, handle)
    glAssert()
  }
  
  func unbind() {
    // TODO: should this be a class function?
    //glEnable(_target); qkgl_assert(); // TODO: necessary in OpenGL? invalid in ES2.
    glBindTexture(target.rawValue, 0)
    glAssert()
  }
}  
