// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


var GLView_dflt_prog: GLProgram! = nil

func GLView_setup() {
  
  let GLView_dflt_vert = GLShader(type: GLenum(GL_VERTEX_SHADER), name: "GLView_dflt_vert", sources: [
    "uniform mediump vec2 screenScale;", // (s.x, -s.y) / 2.
    "uniform mediump vec2 o;",
    "uniform mediump vec2 s;",
    "attribute vec2 unit_pos;",
    "varying vec4 corners;", // TODO: noperspective?
    "void main(void) {",
    "  vec2 screen_pos = (vec2(-.5, -.5) + o + s * unit_pos) / screenScale - vec2(1, -1);",
    "  gl_Position = vec4(screen_pos, 0., 1.);",
    "  corners = vec4(s * unit_pos, s * (vec2(1, 1) - unit_pos));",
    //"  gl_FrontColor = col;",
    "}"
    ])

  let GLView_dflt_frag = GLShader(type: GLenum(GL_FRAGMENT_SHADER), name: "GLView_dflt_frag", sources: [
    "uniform mediump vec4 col;",
    "uniform mediump float cornerRad;",
    "varying vec4 corners;",
    
    "float cPar(vec2 c) {", // corner parameter.
    "  // the 0.75 fudge factor balances between a full circle not looking clipped, and smaller corners not looking inset.",
    "  return max(c.x + c.y - (cornerRad), 0.75 + cornerRad - distance(c, vec2(cornerRad, cornerRad)));",
    "}",
    "void main(void) {",
    "  float cp = min(",
    "    min(cPar(corners.xy), cPar(corners.xw)),",
    "    min(cPar(corners.zy), cPar(corners.zw)));",
    "  float cornerAlpha = clamp(cp, 0.0, 1.0);",
    "  gl_FragColor = vec4(col.xyz, col.w * cornerAlpha);",
    //"  gl_FragColor = gl_Color;",
    "}"
    ])

  // angle corners.
  //"  float cornerDist = min(",
  //"    min(corners.x + corners.y, corners.x + corners.w),",
  //"    min(corners.z + corners.y, corners.z + corners.w));",
  //"  float cornerAlpha = clamp(cornerDist - cornerRad, 0.0, 1.0);",

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
    program.bindUniform("cornerRad", f: cornerRad)
    let vertices = [V2F32(0, 0), V2F32(0, 1), V2F32(1, 0), V2F32(1, 1)]
    program.bindAttr("unit_pos", stride: 0, V2F32: vertices, offset: 0)
    glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    glAssert()
    //println("scr:\(screenScale) o:\(offset + o) s:\(s) col:\(col)\nvert: \(vertices)")
  }
  
}
