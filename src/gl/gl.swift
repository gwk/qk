// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation

#if os(OSX)
  import OpenGL
  import OpenGL.GL
  typealias GLContext = CGLContextObj
  #else
  import OpenGLES
  import OpenGLES.GL
  typealias GLContext = EAGLContext
#endif



typealias GLHandle = GLuint


extension CGLError: Equatable {}
public func ==(a: CGLError, b: CGLError) -> Bool { return a.value == b.value }


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


func glDeleteTextureHandles(textures: GLHandle...) {
  glDeleteTextures(GLint(textures.count), textures)
}


func glProvideShaderSource(shader: GLHandle, source: String) {
  source.withUtf8() {
    (ptr, len) -> () in
    let gp = unsafeBitCast(ptr, UnsafePointer<GLchar>.self)
    let gl = GLint(len)
    let gpa = [gp]
    let gla = [gl]
    glShaderSource(shader, 1, gpa, gla)
    return ()
  }
}


func glContextEnable(ctx: GLContext) {
  var ok = false
  #if os(OSX)
    let error = CGLSetCurrentContext(ctx)
    ok = (error == kCGLNoError)
    #else
    ok = EAGLContext.setCurrentContext(ctx)
  #endif
  if !ok {
    println("GL ERROR: glContextEnable failed for context: \(ctx)")
  }
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


extension PixFmt {

  var glDataFormat: GLenum {
    // OpenGLES 3.0 dataFormat must be one of:
    // GL_RED, GL_RED_INTEGER, GL_RG, GL_RG_INTEGER, GL_RGB, GL_RGB_INTEGER, GL_RGBA, GL_RGBA_INTEGER, GL_ALPHA,
    // GL_DEPTH_COMPONENT, GL_DEPTH_STENCIL, GL_LUMINANCE_ALPHA, GL_LUMINANCE.
    switch self {
    case .RGBU8: return GLenum(GL_RGB)
    case .RGBAU8: return GLenum(GL_RGBA)
    default:
      fatalError("PixFmt is not mapped to OpenGL data format: \(self)")
    }
  }

  var QKPixFmtGlDataType: GLenum {
    // OpenGLES 3.0 dataType must be one of:
    // GL_UNSIGNED_BYTE, GL_BYTE, GL_UNSIGNED_SHORT, GL_SHORT, GL_UNSIGNED_INT, GL_INT, GL_HALF_FLOAT, GL_FLOAT,
    // GL_UNSIGNED_SHORT_5_6_5, GL_UNSIGNED_SHORT_4_4_4_4, GL_UNSIGNED_SHORT_5_5_5_1,
    // GL_UNSIGNED_INT_2_10_10_10_REV, GL_UNSIGNED_INT_10F_11F_11F_REV, GL_UNSIGNED_INT_5_9_9_9_REV,
    // GL_UNSIGNED_INT_24_8, GL_FLOAT_32_UNSIGNED_INT_24_8_REV.
    switch self {
    case .RGBU8: return GLenum(GL_UNSIGNED_BYTE)
    case .RGBAU8: return GLenum(GL_UNSIGNED_BYTE)
    default:
      fatalError("PixFmt is not mapped to OpenGL data type: \(self)")
    }
  }

  var cglColorSize: Int {
    if isLum {
      return bitsPerChannel
    }
    if isRGB {
      return bitsPerChannel * 3
    }
    return 0
  }

}
