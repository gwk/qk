// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


var GLTextView_dflt_prog: GLProgram! = nil

func GLTextView_setup() {
  assert(GLTextView_dflt_prog == nil)
    
  let vert = GLShader(kind: .Vert, name: "GLTextView_dflt_vert", sources: [
    "attribute vec2 glPos;",
    "attribute vec2 texPos;",
    "varying vec2 texPosF;",
    "void main(void) {",
    "  gl_Position = vec4(glPos, 0.0, 1.0);",
    "  texPosF = texPos;",
    //"  gl_FrontColor = color;",
    "}"
    ])
  
  let frag = GLShader(kind: .Frag, name: "GLTextView_dflt_frag", sources: [
    "uniform mediump vec4 color;",
    "uniform mediump sampler2D tex;",
    "varying vec2 texPosF;",
    "void main(void) {",
    "  vec4 texel = texture2D(tex, texPosF);", // TODO: texelFetch.
    "  gl_FragColor = vec4(color.rgb, color.a * texel.r);",
    //"  gl_FragColor = color;",
    "}"
    ])
  
  GLTextView_dflt_prog = GLProgram(vert, frag)
}


class GLTextView: View {
  var _text: String = ""
  var _fontSize: F32 = 16 // key into GLTextAtlas page dictionary.
  var _kern: F32 = 1
  var atlas: GLTextAtlas

  init(_ name: String, atlas: GLTextAtlas) {
    self.atlas = atlas
    super.init(name, program: GLTextView_dflt_prog, tex: nil)
  }
  
  var text: String {
    get { return _text }
    set {
      if _text != newValue {
        _text = newValue
        needsLayout = true
      }
    }
  }
  
  var fontSize: F32 {
    get { return _fontSize }
    set {
      if _fontSize != newValue {
        _fontSize = newValue
        needsLayout = true
      }
    }
  }
  
  var kern: F32 {
    get { return _kern }
    set {
      if _kern == newValue { return }
      _kern = newValue
      needsLayout = true
    }
  }
  
  func atlasPage(pxPerPt: F32) -> GLTextPage {
    return atlas.page(fontSize, pxPerPt: pxPerPt)
  }
  
  override func layout() {
    //println("text layout")
    
  }
  
  override func render(pxPerPt: F32, screenSizePt: V2S, offset: V2S) {
    let page = atlasPage(pxPerPt) // all page metrics are in px units, so we do all layout in screenPxSpace.
    let metrics = page.metrics
    let maxAdv = round(F32(metrics.maxAdv) * kern)
    let lineHeight = F32(page.metrics.lineHeight)
    let screenSizePx = screenSizePt * pxPerPt
    let offsetPx = offset * pxPerPt
    let sizePx = s * pxPerPt
    if sizePx.y < lineHeight { return }
    // glSpace has has range of (-1, 1), hence scaling by 2 from unit scale.
    let scale = V2S(2 / screenSizePx.x, -2 / screenSizePx.y) // scale from pxScale to glScale; flips y.
    let trans = V2S(-1, 1) // translate to glSpace origin; upper left of viewport  is (-1, 1).
    typealias Vertex = (V2S, V2S)
    var verts: [Vertex] = []
    var pos = offsetPx // current character layout position in screenPxSpace (upper left).
    //println("\nRENDER: offset:\(offset) page:\(page)")
    for c in text.characters {
      // TODO: word wrapping.
      if c == "\n" || pos.x + maxAdv > sizePx.x { // spill to next line.
        pos.x = offsetPx.x
        pos.y += lineHeight
        if sizePx.y < pos.y + lineHeight { break }
        if c == "\n" || c == " " { continue }
      }
      if c == " " {
        pos.x += maxAdv
        continue
      }
      if let g = page.glyph(c) {
        // transform from viewPointSpace to glSpace.
        let goPx = pos + g.orig.vs // glyph origin in screenPxSpace.
        let gePx = goPx + g.size.vs // glyph end (high values of rect) in screenPxSpace.
        let go = goPx * scale + trans // glSpace.
        let ge = gePx * scale + trans // glSpace.
        let toTx = g.texOrig.vs // glyph texture origin in texel space.
        let teTx = toTx + g.size.vs // glyph texture end in texel space.
        let pageSize = page.size.vs
        let to = toTx / pageSize // texture unit space.
        let te = teTx / pageSize // texture unit space.
        let v0 = Vertex(go, to)
        let v1 = Vertex(V2S(go.x, ge.y), V2S(to.x, te.y))
        let v2 = Vertex(V2S(ge.x, go.y), V2S(te.x, to.y))
        let v3 = Vertex(ge, te)
        // ccw triangles; v2 and v3 are repeated due to shared edge.
        verts.appendContentsOf([v0, v1, v2, v1, v3, v2])
        pos.x += F32(g.adv)
      } else { // missing glyph
        pos.x += maxAdv
      }
    }
    let stride = sizeof(Vertex)
    program.use()
    program.bindUniform("color", v4: color)
    program.bindUniform("tex", tex: page.tex, unit: 0)
    program.bindAttr("glPos", stride: stride, V2S: verts, offset: 0)
    program.bindAttr("texPos", stride: stride, V2S: verts, offset: sizeof(V2S))
    glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(verts.count))
    glAssert()
  }
}
