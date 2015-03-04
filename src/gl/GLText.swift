// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import CoreGraphics

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


var GLTextView_dflt_prog: GLProgram! = nil

func GLTextView_setup() {
  assert(GLTextView_dflt_prog == nil)
  
  let vert = GLShader(type: GLenum(GL_VERTEX_SHADER), name: "GLTextView_dflt_vert", sources: [
    "attribute vec2 glPos;",
    "attribute vec2 texPos;",
    "varying vec2 texPosF;",
    "void main(void) {",
    "  gl_Position = vec4(glPos, 0.0, 1.0);",
    "  texPosF = texPos;",
    //"  gl_FrontColor = color;",
    "}"
    ])
  
  let frag = GLShader(type: GLenum(GL_FRAGMENT_SHADER), name: "GLTextView_dflt_frag", sources: [
    "uniform mediump vec4 color;",
    "uniform mediump sampler2D tex;",
    "varying vec2 texPosF;",
    "void main(void) {",
    "  vec4 texel = texture2D(tex, texPosF);", // TODO: texelFetch.
    "  gl_FragColor = vec4(color.rgb, color.a * texel.r);",
    //"  gl_FragColor = gl_Color;",
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
    println("text layout")
    
  }
  
  override func render(pxPerPt: F32, screenSizePt: V2S, offset: V2S) {
    let page = atlasPage(pxPerPt) // all page metrics are in px units, so we do all layout in screenPxSpace.
    let screenSizePx = screenSizePt * pxPerPt
    let offsetPx = offset * pxPerPt
    let sPx = s * pxPerPt
    let lineHeight: F32 = F32(page.lineHeight)
    let advance: F32 = F32(page.advance) * kern
    if sPx.y < lineHeight { return }
    // glSpace has has range of (-1, 1), hence scaling by 2 from unit scale.
    let scale = V2S(2 / screenSizePx.x, -2 / screenSizePx.y) // scale from pxScale to glScale; flips y.
    let trans = V2S(-1, 1) // translate to glSpace origin; upper left of viewport  is (-1, 1).
    typealias Vertex = (V2S, V2S)
    var verts: [Vertex] = []
    var pos = offsetPx // current character layout position in screenPxSpace (upper left).
    //println("\nRENDER: offset:\(offset) page:\(page)")
    for c in text {
      if c == "\n" || pos.x + advance > sPx.x { // spill to next line.
        pos.x = offsetPx.x
        pos.y += lineHeight
        if sPx.y < pos.y + lineHeight { break }
        if c == "\n" || c == " " { continue }
      }
      if c == " " {
        pos.x += advance
        continue
      }
      if let g = page.glyph(c) {
        // transform from viewPointSpace to glSpace.
        let goPx = pos + V2S(F32(g.gox), F32(g.goy)) // glyph origin in screenPxSpace.
        let gePx = goPx + V2S(F32(g.tsw), F32(g.tsh)) // glyph end (high values of rect) in screenPxSpace.
        let go = goPx * scale + trans // glSpace.
        let ge = gePx * scale + trans // glSpace.
        let toTx = V2S(F32(g.tox), F32(g.toy)) // glyph texture origin in texel space.
        let teTx = toTx + V2S(F32(g.tsw), F32(g.tsh)) // glyph texture end in texel space.
        let pageSize = V2S(F32(page.w), F32(page.h))
        let to = toTx / pageSize // texture unit space.
        let te = teTx / pageSize // texture unit space.
        //println("pos:\(pos)")
        //println("g:\(g)")
        //println("goPx:\(goPx) gePx:\(gePx) go:\(go) ge:\(ge)")
        //println("toTx:\(toTx) teTx:\(teTx) to:\(to) te:\(te)")
        let v0 = Vertex(go, to)
        let v1 = Vertex(V2S(go.x, ge.y), V2S(to.x, te.y))
        let v2 = Vertex(V2S(ge.x, go.y), V2S(te.x, to.y))
        let v3 = Vertex(ge, te)
        // ccw triangles; v2 and v3 are repeated due to shared edge.
        verts.extend([v0, v1, v2, v1, v3, v2])
      } else { // missing glyph
        
      }
      pos.x += advance
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


struct GLGlyph: Printable {
  let gox: Int // glyph origin offset from tx (positive).
  let goy: Int // glyph origin offset from tx (positive).
  let tox: Int // texture offset.
  let toy: Int // texture offset.
  let tsw: Int
  let tsh: Int
  
  var description: String { return "GLGlyph(go:(\(gox), \(goy)), to:(\(tox), \(toy)), ts:(\(tsw), \(tsh))" }
}


func _createContext(w: Int, h: Int) -> CGContext {
  assert(w > 0 && h > 0)
  let cs = CGColorSpaceCreateDeviceGray()
  // TODO: use alphaOnly context?
  let info = CGBitmapInfo(CGImageAlphaInfo.None.rawValue | CGBitmapInfo.ByteOrderDefault.rawValue)
  let ctx = CGBitmapContextCreate(nil, // manage data internally.
    w,
    h,
    8, // bits per channel.
    w, // bytes per row.
    cs,
    info)
  assert(ctx != nil)
  return ctx
}


struct GLTextPage: Printable {
  let fontName: String
  let chars: Index<Character>
  let glyphs: [GLGlyph]
  let fontSize: F32
  let advance: Int // for now, assume monospace.
  let lineHeight: Int
  let ascent: Int
  let descent: Int // positive value from baseline to max descender; CRFont returns a negative value.
  let rows: Int
  let w: Int
  let h: Int
  let tex: GLTexture
  
  var description: String { return "GLTextPage(\(fontName) fontSize:\(fontSize) adv:\(advance) lineHeight:\(lineHeight) ascent:\(ascent) descent:\(descent) rows:\(rows) w:\(w) h:\(h))" }
  
  init(fontName: String, fontSize: F32, chars: Index<Character>) {
    self.fontName = fontName
    self.fontSize = fontSize
    self.chars = chars
    let font = CRFont(name: fontName, size: Flt(fontSize))!
    let descriptor = font.fontDescriptor
    let attributes = descriptor.fontAttributes
    var advance = Int(font.fixedAdvance.ceil) // this usually returns 0.
    if advance == 0 {
      advance = Int((font.lineHeight * 0.5).ceil)
    }
    lineHeight = Int(font.lineHeight.ceil)
    ascent = Int(font.ascender.ceil)
    var descent = -Int(font.descender.floor) // CRFont returns negative descender value.
    assert(descent >= 0)
    self.descent = descent
    //let glyphRect = font.boundingRectForFont
    // generate strings and glyph info prior to allocating canvas.
    var attrStrings: [NSAttributedString] = []
    let style = NSMutableParagraphStyle()
    style.lineBreakMode = .ByCharWrapping
    style.alignment = .LeftTextAlignment
    let attrs: [NSObject : AnyObject] = [
      NSFontAttributeName: font,
      NSForegroundColorAttributeName: CRColor.w, // any color seems to work; the attribute must be present.
      NSParagraphStyleAttributeName: style]
    let ctx0 = _createContext(1, 1)
    var lines: [CTLine] = []
    
    struct GlyphRect: Printable {
      let gox: Int
      let goy: Int
      let tsw: Int
      let tsh: Int
      var description: String { return "GlyphRect(go:(\(gox), \(goy)), ts:(\(tsw), \(tsh))" }
    }
    
    var glyphRects: [GlyphRect] = []
    var maxGlyphHeight = 0 // for now, rows are uniform height.
    for (i, c) in enumerate(chars.vals) {
      let attrString = NSAttributedString(string: String(c), attributes: attrs)
      let line = CTLineCreateWithAttributedString(attrString)
      lines.append(line)
      let b = CGRectIntegral(CTLineGetImageBounds(line, ctx0)) // note: CoreText orientation is bottom-up; ours is top-down.
      if advance == 0 { // TODO: currently disabled because the typographic width appears too large for correct advancement.
        let width = CTLineGetTypographicBounds(line, nil, nil, nil)
        let trailing = CTLineGetTrailingWhitespaceWidth(line)
        println("line typographic width: \(width) trailing: \(trailing)")
        advance = Int(width.ceil)
      }
      let goy = ascent - Int((b.y + b.h).ceil) // TODO: figure out exactly how the rounding should work here; the CT baseline is not guaranteed to be pixel aligned, but ours is by virtue of rounding the ascent?
      let gr = GlyphRect(gox: Int(b.x), goy: goy, tsw: Int(b.w.ceil), tsh: Int(b.h.ceil))
      glyphRects.append(gr)
      maxGlyphHeight = max(maxGlyphHeight, Int(b.h))
    }
    self.advance = advance
    assert(GLTexture_maxSize > 0)
    // choose size and layout glyphs.
    var glyphs:[GLGlyph] = []
    // TEMP!!
    let wMax = 2048 // GLTexture_maxSize // maxSize is a bad choice because it may leave lots of empty space left over on the final row.
    var w = 0
    var rows = 1
    var tx = 0 // current texture offset.
    var ty = 0
    for r in glyphRects {
      assert(r.tsw < wMax)
      if tx + r.tsw > wMax { // spill to next line.
        tx = 0
        ty += maxGlyphHeight
        rows++
      }
      w = max(w, tx + r.tsw)
      glyphs.append(GLGlyph(gox: r.gox, goy: r.goy, tox: tx, toy: ty, tsw: r.tsw, tsh: r.tsh))
      tx += r.tsw
    }
    self.glyphs = glyphs
    self.rows = rows
    h = rows * maxGlyphHeight
    //println("real size: \(w) \(h)")
    w = ((w + 3) >> 2) << 2 // in certain cases (e.g. "0123" charset) odd widths cause staggering in the texture; padding up to word fixes it.
    self.w = w
    // allocate ctx and draw glyphs.
    let ctx = _createContext(w, h)
    let rect = CGRect(x: 0, y: 0, width: w, height: h)
    CGContextClearRect(ctx, rect)
    CGContextSetFillColor(ctx, [1.0, 1.0, 1.0, 1.0])
    CGContextSetStrokeColor(ctx, [1.0, 1.0, 1.0, 0.5])
    CGContextSetLineWidth(ctx, 1.0)
    CGContextScaleCTM(ctx, 1, -1)
    CGContextTranslateCTM(ctx, 0, Flt(-h))
    for i in 0..<chars.count {
      CGContextSaveGState(ctx)
      let l = lines[i]
      let g = glyphs[i]
      CGContextTranslateCTM(ctx, Flt(g.tox), Flt(g.toy))
      let r = CGRect(0, 0, Flt(g.tsw), Flt(g.tsh))
      //CGContextStrokeRect(ctx, r)
      let textScale = CGAffineTransformMakeScale(1, -1)
      let textMat = CGAffineTransformTranslate(textScale, Flt(-g.gox), Flt(g.goy - ascent))
      CGContextSetTextMatrix(ctx, textMat)
      CTLineDraw(l, ctx)
      CGContextRestoreGState(ctx)
    }
    // allocate texture.
    tex = GLTexture()
    let dataU8 = UnsafePointer<U8>(CGBitmapContextGetData(ctx))
    let bytes = Array<U8>(UnsafeBufferPointer<U8>(start: dataU8, count: w * h))
    #if false
      println(self)
      println("asc: \(font.ascender); desc: \(font.descender); lead: \(font.leading) maxGlyphHeight:\(maxGlyphHeight)")
      let string = String(chars.vals)
      println("chars: '\(string)'")
      for j in 0..<h {
        var s = ""
        for i in 0..<min(w, 74) {
          var v = Int(bytes[j * w + i])
          var si = (v == 0) ? "__" : v.h0(2)
          s.extend(si)
        }
        println(s)
      }
      println()
    #endif
    tex.update(w , h,
      format: GLenum(GL_RED),
      dataFormat: GLenum(GL_RED),
      dataType: GLenum(GL_UNSIGNED_BYTE),
      data: CGBitmapContextGetData(ctx))
  }
  
  func glyph(char: Character) -> GLGlyph? {
    if let i = chars.index(char) {
      return glyphs[i]
    } else {
      return nil
    }
  }
}


class GLTextAtlas {
  let fontName: String
  let sizes: [F32]
  let chars: Index<Character>
  var pages: [F32:GLTextPage] = [:] // keyed by font size.
  
  init(fontName: String, maxSize: F32, maxPxPerPt: F32, charsArray: [Character]) {
    GLTexture_getMaxSize()
    let chars = Index(charsArray)
    self.fontName = fontName
    var sizes:[F32] = []
    for i in HPOTSeq() {
      let f = F32(i)
      if f > maxSize * maxPxPerPt { break }
      sizes.append(f)
    }
    self.sizes = sizes
    self.chars = chars
    self.pages = mapToDict(sizes) { return ($0, GLTextPage(fontName: fontName, fontSize: $0, chars: chars)) }
  }
  
  func page(size: F32, pxPerPt: F32) -> GLTextPage {
    return pages[size * pxPerPt]!
  }
}



