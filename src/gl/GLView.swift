// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


var GLView_dflt_prog: GLProgram! = nil

func GLView_setup() {
  
  let GLView_dflt_vert = GLShader(type: GLenum(GL_VERTEX_SHADER), name: "GLView_dflt_vert", sources: [
    "uniform mediump vec2 screenScale;", // (s.x, -s.y) / 2.
    "uniform mediump vec2 o;",
    "uniform mediump vec2 s;",
    "uniform mediump vec4 col;",
    "attribute vec2 unit_pos;",
    "void main(void) {",
    "  vec2 screen_pos = (o + s * unit_pos) / screenScale - vec2(1, -1);",
    "  gl_Position = vec4(screen_pos, 0., 1.);",
    "  gl_FrontColor = col;",
    "}"
    ])

  let GLView_dflt_frag = GLShader(type: GLenum(GL_FRAGMENT_SHADER), name: "GLView_dflt_frag", sources: [
    "void main(void) {",
    "  gl_FragColor = gl_Color;",
    "}"
    ])

  GLView_dflt_prog = GLProgram(GLView_dflt_vert, GLView_dflt_frag)
}


class GLView {
  var program: GLProgram
  var cornerRad: F32 = 0
  var subs: [GLView] = []
  
  var o: V2F32 = V2F32()
  var _s: V2F32 = V2F32()
  var col: V4F32 = V4F32(1, 1, 1, 1)
  var needsLayout: Bool = true
  
  init(program: GLProgram? = nil, tex: GLTexture? = nil) {
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
  
  func render(screenScale: V2F32, offset: V2F32) {
    updateLayout()
    program.use()
    program.bindUniform("screenScale", v2: screenScale)
    program.bindUniform("o", v2: offset + o)
    program.bindUniform("s", v2: s)
    program.bindUniform("col", v4: col)
    let vertices = [V2F32(0, 0), V2F32(0, 1), V2F32(1, 0), V2F32(1, 1)]
    program.bindAttr("unit_pos", stride: 0, V2F32: vertices, offset: 0)
    glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    glAssert()
    //println("scr:\(screenScale) o:\(offset + o) s:\(s) col:\(col)\nvert: \(vertices)")
  }
  
}
