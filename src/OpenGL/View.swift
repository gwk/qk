// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation

#if os(OSX)
  import OpenGL
  import OpenGL.GL
  #else
  import OpenGLES
  import OpenGLES.GL
#endif


var View_dflt_prog: GLProgram! = nil

func View_setup() {
  assert(View_dflt_prog == nil)
  
  View_dflt_prog = GLProgram(name: "View_dflt", sources: [
    "varying vec2 cornerPosF;", // TODO: noperspective qualifier?

    "vert:",
    "attribute vec2 glPos;",
    "attribute vec2 cornerPos;",
    "void main(void) {",
    "  gl_Position = vec4(glPos, 0.0, 1.0);",
    "  cornerPosF = cornerPos;",
    //"  gl_FrontColor = color;",
    "}",

    "frag:",
    "uniform mediump vec4 color;",
    "uniform mediump float cornerRadPx;",
    "void main(void) {",
    "  vec2 c = cornerPosF;",
    "  float r = cornerRadPx;",
    "  float t = max(",
    "    c.x + c.y - r,",
    "    0.5 + r - distance(c, vec2(r, r)));",
    "  float cornerAlpha = clamp(t, 0.0, 1.0);",
    "  gl_FragColor = vec4(color.rgb, color.a * cornerAlpha);",
    //"  gl_FragColor = gl_Color;",
    "}"
    ])
}


class View {
  let name: String
  var program: GLProgram
  var cornerRad: F32 = 0
  var subs: [View] = []
  
  var o: V2S = V2S()
  var _s: V2S = V2S()
  var pan: V2S = V2S()
  var color: V4S = V4S()
  var needsLayout: Bool = true
  
  init(_ name: String, program: GLProgram? = nil, tex: GLTexture? = nil) {
    self.name = name
    self.program = program.or(View_dflt_prog)
  }
  
  var s: V2S {
    get { return _s }
    set {
      if _s != newValue {
        _s = newValue
        needsLayout = true
      }
    }
  }
  
  func layout() {}
  
  func render(_ pxPerPt: F32, screenSizePt: V2S, offset: V2S) {
    // glSpace has has range of (-1, 1), hence scaling by 2 from unit scale.
    let scale = V2S(2 / screenSizePt.x, -2 / screenSizePt.y) // scale from ptScale to glScale; flips y.
    let trans = V2S(-1, 1) // translate to glSpace origin; upper left of viewport  is (-1, 1).
    typealias Vertex = (V2S, V2S)
    func v(_ x: F32, y: F32) -> Vertex { // transform from viewUnitSpace to glSpace.
      return (
        ((V2S(x, y) * self.s) + offset) * scale + trans, // glPos.
        V2S( // cornerPos: distance in px from the corner. TODO: implement abs for vectors, use vector math.
          pxPerPt * self.s.x * (0.5 - abs(x - 0.5)),
          pxPerPt * self.s.y * (0.5 - abs(y - 0.5))))
    }
    // triangle fan starting from center, then upper left corner, left midpoint, and around counterclockwise.
    // this gives us triangles with exactly one point at the corner, simplifying the corner rounding fragment shader.
    let verts = [v(0.5, y: 0.5), v(0, y: 0), v(0, y: 0.5), v(0, y: 1), v(0.5, y: 1), v(1, y: 1), v(1, y: 0.5), v(1, y: 0), v(0.5, y: 0), v(0, y: 0)]
    let stride = sizeof(Vertex)
    program.use()
    program.bindUniform("color", v4: color)
    program.bindUniform("cornerRadPx", f: cornerRad * pxPerPt)
    program.bindAttr("glPos", stride: stride, V2S: verts, offset: 0)
    program.bindAttr("cornerPos", stride: stride, V2S: verts, offset: sizeof(V2S))
    glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, 10)
    glAssert()
  }
  
  func renderTree(_ pxPerPt: F32, screenSizePt: V2S, parentOffset: V2S = V2S()) {
    glEnable(GLenum(GL_BLEND))
    glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
    if needsLayout {
      layout()
      needsLayout = false
    }
    let offset = parentOffset + o
    if color.w > 0 {
      render(pxPerPt, screenSizePt: screenSizePt, offset: offset)
    }
    for sv: View in subs {
      // TODO: only add pan if subview is marked with isPanning.
      sv.renderTree(pxPerPt, screenSizePt: screenSizePt, parentOffset: offset)
    }
  }
}
