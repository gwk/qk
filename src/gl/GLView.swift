// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


var GLView_dflt_prog: GLProgram! = nil

func GLView_setup() {
  
  let GLView_dflt_vert = GLShader(type: GLenum(GL_VERTEX_SHADER), name: "GLView_dflt_vert", sources: [
    "attribute vec2 glPos;",
    "attribute vec2 cornerPos;",
    "varying vec2 cornerPosF;", // TODO: noperspective qualifier?
    "void main(void) {",
    "  gl_Position = vec4(glPos, 0.0, 1.0);",
    "  cornerPosF = cornerPos;",
    //"  gl_FrontColor = color;",
    "}"
    ])

  let GLView_dflt_frag = GLShader(type: GLenum(GL_FRAGMENT_SHADER), name: "GLView_dflt_frag", sources: [
    "uniform mediump vec4 color;",
    "uniform mediump float cornerRad;",
    "varying vec2 cornerPosF;",
    "void main(void) {",
    "  vec2 c = cornerPosF;",
    "  float cornerPar = max(",
    "    c.x + c.y - cornerRad,",
    "    0.5 + cornerRad - distance(c, vec2(cornerRad, cornerRad)));",
    "  float cornerAlpha = clamp(cornerPar, 0.0, 1.0);",
    "  gl_FragColor = vec4(color.rgb, color.a * cornerAlpha);",
    //"  gl_FragColor = gl_Color;",
    "}"
    ])

  GLView_dflt_prog = GLProgram(GLView_dflt_vert, GLView_dflt_frag)
}


class GLView {
  let name: String
  var program: GLProgram
  var cornerRad: F32 = 0
  var subs: [GLView] = []
  
  var o: V2F32 = V2F32()
  var _s: V2F32 = V2F32()
  var pan: V2F32 = V2F32()
  var color: V4F32 = V4F32()
  var needsLayout: Bool = true
  
  init(_ name: String, program: GLProgram? = nil, tex: GLTexture? = nil) {
    self.name = name
    self.program = program.or(GLView_dflt_prog)
  }
  
  var s: V2F32 {
    get { return _s }
    set {
      if _s != newValue {
        _s = newValue
        needsLayout = true
      }
    }
  }
  
  func layout() {}
  
  func updateLayout() {
    if needsLayout {
      layout()
      needsLayout = false
    }
  }
  
  func render(scaleFactor: Flt, screenSize: V2F32, offset: V2F32) {
    updateLayout()
    let vo = offset + o
    let sf = F32(scaleFactor)
    let glScale: F32 = 2 * sf // factor of 2 is due to glSpace range of (-1, 1).
    typealias Vertex = (V2F32, V2F32)
    func v(x: F32, y: F32) -> Vertex { // transform from unitViewSpace to glSpace.
      return (
        V2F32( // glPos.
          ( glScale * (vo.x + (x * s.x)) / screenSize.x) - 1,
          (-glScale * (vo.y + (y * s.y)) / screenSize.y) + 1),
        V2F32( // cornerPos; units are in device pixels, and denote the distance from the corner.
          sf * s.x * (0.5 - abs(x - 0.5)),
          sf * s.y * (0.5 - abs(y - 0.5))))
    }
    // triangle fan starting from center, then upper left corner, left midpoint, and around counterclockwise.
    // this gives us triangles with exactly one point at the corner, simplifying the corner rounding fragment shader.
    let vertices = [v(0.5, 0.5), v(0, 0), v(0, 0.5), v(0, 1), v(0.5, 1), v(1, 1), v(1, 0.5), v(1, 0), v(0.5, 0), v(0, 0)]
    let stride = sizeof(Vertex)
    program.use()
    program.bindUniform("color", v4: color)
    program.bindUniform("cornerRad", f: cornerRad * sf)
    program.bindAttr("glPos", stride: stride, V2F32: vertices, offset: 0)
    program.bindAttr("cornerPos", stride: stride, V2F32: vertices, offset: sizeof(V2F32))
    glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, 10)
    glAssert()
  }
  
  func renderTree(scaleFactor: Flt, screenSize: V2F32, offset: V2F32) {
    if color.w > 0 {
      render(scaleFactor, screenSize: screenSize, offset: offset)
    }
    let subOffset = offset + pan
    for sv: GLView in subs {
      sv.renderTree(scaleFactor, screenSize: screenSize, offset: subOffset)
    }
  }
}
