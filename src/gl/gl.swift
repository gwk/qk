// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


func glErrorString(code: GLenum) -> String {
  switch code {
  case GLenum(GL_NO_ERROR): return "GL_NO_ERROR"
  case GLenum(GL_INVALID_ENUM): return "GL_INVALID_ENUM"
  case GLenum(GL_INVALID_VALUE): return "GL_INVALID_VALUE"
  case GLenum(GL_INVALID_OPERATION): return "GL_INVALID_OPERATION"
  case GLenum(GL_OUT_OF_MEMORY): return "GL_OUT_OF_MEMORY"
  default:
    let hex = NSString(format:"%2x", code)
    return "UNKNOWN: 0x\(hex)"
  }
}

func glCheck() {
  var code: GLenum = glGetError()
  if code == GLenum(GL_NO_ERROR) {
    return
  }
  // OpenGL spec says multiple errors may be set, and that we should always get them all.
  var s = String()
  while code != GLenum(GL_NO_ERROR) {
    let e = glErrorString(code)
    s.extend(" ")
    s.extend(e)
    code = glGetError()
  }
  fatalError("glCheck: \(s)")
}

func glAssert() {
  #if DEBUG
    glCheck()
  #endif
}

func viewportOriginLetterboxed(origin: V2, contentAR: Flt, canvasAR: Flt) -> V2 {
  if contentAR <= 0 || canvasAR <= 0 {
    return origin
  }
  let ar = contentAR / canvasAR
  if ar > 1 { // content is wide compared to canvas; letterbox y.
    return V2(origin.x, origin.y + (1 - ar) * 0.5)
  } else { // content is narrow; letterbox x.
    return V2(origin.x + (1 - (1 / ar)) * 0.5, origin.y)
  }
}


func viewportScaleLetterboxed(scale: V2, contentAR: Flt, canvasAR: Flt) -> V2 {
  if contentAR <= 0 || canvasAR <= 0 {
    return scale
  }
  let ar = contentAR / canvasAR
  if ar > 1 { // content is wide compared to canvas; letterbox y.
    return V2(scale.x, scale.y / ar)
  } else { // content is narrow; letterbox x
    return V2(scale.x * ar, scale.y)
  }
}

