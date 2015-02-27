// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


var GLView_dflt_prog: GLProgram! = nil

func GLView_setup() {
  assert(GLView_dflt_prog == nil)
  
  let vert = GLShader(type: GLenum(GL_VERTEX_SHADER), name: "GLView_dflt_vert", sources: [
    "attribute vec2 glPos;",
    "attribute vec2 cornerPos;",
    "varying vec2 cornerPosF;", // TODO: noperspective qualifier?
    "void main(void) {",
    "  gl_Position = vec4(glPos, 0.0, 1.0);",
    "  cornerPosF = cornerPos;",
    //"  gl_FrontColor = color;",
    "}"
    ])

  let frag = GLShader(type: GLenum(GL_FRAGMENT_SHADER), name: "GLView_dflt_frag", sources: [
    "uniform mediump vec4 color;",
    "uniform mediump float cornerRadPx;",
    "varying vec2 cornerPosF;",
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

  GLView_dflt_prog = GLProgram(vert, frag)
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
  
  func render(pxPerPt: F32, screenSizePt: V2F32, offset: V2F32) {
    // glSpace has has range of (-1, 1), hence scaling by 2 from unit scale.
    let scale = V2F32(2 / screenSizePt.x, -2 / screenSizePt.y) // scale from ptScale to glScale; flips y.
    let trans = V2F32(-1, 1) // translate to glSpace origin; upper left of viewport  is (-1, 1).
    typealias Vertex = (V2F32, V2F32)
    func v(x: F32, y: F32) -> Vertex { // transform from viewUnitSpace to glSpace.
      return (
        ((V2F32(x, y) * self.s) + offset) * scale + trans, // glPos.
        V2F32( // cornerPos: distance in px from the corner. TODO: implement abs for vectors, use vector math.
          pxPerPt * self.s.x * (0.5 - abs(x - 0.5)),
          pxPerPt * self.s.y * (0.5 - abs(y - 0.5))))
    }
    // triangle fan starting from center, then upper left corner, left midpoint, and around counterclockwise.
    // this gives us triangles with exactly one point at the corner, simplifying the corner rounding fragment shader.
    let verts = [v(0.5, 0.5), v(0, 0), v(0, 0.5), v(0, 1), v(0.5, 1), v(1, 1), v(1, 0.5), v(1, 0), v(0.5, 0), v(0, 0)]
    let stride = sizeof(Vertex)
    program.use()
    program.bindUniform("color", v4: color)
    program.bindUniform("cornerRadPx", f: cornerRad * pxPerPt)
    program.bindAttr("glPos", stride: stride, V2F32: verts, offset: 0)
    program.bindAttr("cornerPos", stride: stride, V2F32: verts, offset: sizeof(V2F32))
    glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, 10)
    glAssert()
  }
  
  func renderTree(pxPerPt: F32, screenSizePt: V2F32, parentOffset: V2F32 = V2F32()) {
    if needsLayout {
      layout()
      needsLayout = false
    }
    let offset = parentOffset + o
    if color.w > 0 {
      render(pxPerPt, screenSizePt: screenSizePt, offset: offset)
    }
    for sv: GLView in subs {
      // TODO: only add pan if subview is marked with isPanning.
      sv.renderTree(pxPerPt, screenSizePt: screenSizePt, parentOffset: offset)
    }
  }
}
