// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


class GLTextView: GLView {
  var _text: String = ""
  var _textSize: Int = 16
  var _kern: Flt = 0
  var atlas: GLTextAtlas

  init(atlas: GLTextAtlas) {
    self.atlas = atlas
    super.init(program: nil, tex: nil)
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
  
  var textSize: Int {
    get { return _textSize }
    set {
      if _textSize != newValue {
        _textSize = newValue
        needsLayout = true
      }
    }
  }
  
  var kern: Flt {
    get { return _kern }
    set {
      if _kern == newValue { return }
      _kern = newValue
      needsLayout = true
    }
  }
  
  override func layout() {
  }
  
  override func render(screenScale: V2F32, offset: V2F32) {
    // bind program
    // bind origin
    // gen quads up to size
    // draw quads
  }
}


struct GLGlyph: Printable {
  let tx: Int // texture offset.
  let ty: Int // texture offset.
  let gx: Int // glyph origin offset from tx (positive).
  let gy: Int // glyph origin offset from tx (positive).
  let w: Int
  let h: Int
  
  var description: String { return "GLGlyph(\(tx), \(ty), \(gx), \(gy), \(w), \(h))" }
}


struct GLGlyphRect: Printable {
  let gx: Int
  let gy: Int
  let w: Int
  let h: Int

  var description: String { return "GLGlyphRect(\(gx), \(gy), \(w), \(h))" }
}


func _createContext(w: Int, h: Int) -> CGContext {
  let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()
  let info = CGBitmapInfo(CGImageAlphaInfo.None.rawValue | CGBitmapInfo.ByteOrderDefault.rawValue)
  return CGBitmapContextCreate(nil, // manage data internally.
    Uns(w),
    Uns(h),
    8, // bits per channel.
    Uns(w), // bytes per row.
    cs,
    info)
}


struct GLTextPage {
  let fontName: String
  let chars: Index<Character>
  let glyphs: [GLGlyph]
  let advance: Int // for now, assume monospace.
  let rows: Int
  let w: Int
  let h: Int
  let tex: GLTexture
  
  /*
  func texOriginForChar(char: Character) -> V2 {
    let i = chars.index(char)
    return V2(x: (i % cols) * glyphW, y: (i / cols) * glyphH)
  }
  */
  init(fontName: String, advance: Int, chars: Index<Character>) {
    self.fontName = fontName
    self.advance = advance
    self.chars = chars
    let font = CRFont(name: fontName, size: Flt(advance * 2))!
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
    var glyphRects: [GLGlyphRect] = []
    var gh = 0 // for now, rows are uniform height.
    for (i, c) in enumerate(chars.vals) {
      let attrString = NSAttributedString(string: String(c), attributes: attrs)
      let line = CTLineCreateWithAttributedString(attrString)
      lines.append(line)
      let b = CGRectIntegral(CTLineGetImageBounds(line, ctx0))
      glyphRects.append(GLGlyphRect(gx: Int(-b.x), gy: Int(-b.y), w: Int(b.w), h: Int(b.h)))
      gh = max(gh, Int(b.h))
    }
    assert(GLTexture_maxSize > 0)
    // choose size and layout glyphs.
    glyphs = []
    let wMax = GLTexture_maxSize // maxSize is acutally a bad choice because it leaves lots left over on the final row.
    w = 0
    h = gh
    rows = 1
    var tx = 0 // current texture offset.
    var ty = 0
    for r in glyphRects {
      assert(r.w < wMax)
      //println("r: \(r)")
      if tx + r.w > wMax { // spill to next line.
        //println("spill")
        tx = 0
        ty += gh
        rows++
        h += gh
      }
      w = max(w, tx + r.w)
      glyphs.append(GLGlyph(tx: tx, ty: ty, gx: r.gx, gy: r.gy, w: r.w, h: r.h))
      tx += r.w
    }
    h = rows * gh
    // allocate ctx and draw glyphs.
    let ctx = _createContext(w, h)
    let rect = CGRect(x: 0, y: 0, width: w, height: h)
    CGContextClearRect(ctx, rect)
    CGContextSetFillColor(ctx, [1.0, 1.0, 1.0, 1.0])
    for i in 0..<chars.count {
      let l = lines[i]
      let g = glyphs[i]
      //println("g: \(g)")
      let textMat = CGAffineTransformMakeTranslation(Flt(g.tx + g.gx), Flt(g.ty + g.gy))
      CGContextSetTextMatrix(ctx, textMat)
      CTLineDraw(l, ctx)
    }
    // allocate texture.
    tex = GLTexture()
    let dataU8 = UnsafePointer<U8>(CGBitmapContextGetData(ctx))
    let bytes = Array<U8>(UnsafeBufferPointer<U8>(start: dataU8, count: w * h))
    #if false
      println("\nadvance: \(advance); w:\(w) h:\(h)")
      println("asc: \(font.ascender); desc: \(font.descender); lead: \(font.leading)")
      let string = String(chars.vals)
      println("chars: '\(string)'")
      for j in 0..<h {
        var s = ""
        for i in 0..<min(w, 64) {
          var v = Int(bytes[j * w + i])
          var si = (v == 0) ? "__" : v.h0(2)
          s.extend(si)
        }
        println(s)
      }
      println()
    #endif
    tex.update(w, h,
      format: GLenum(GL_RED),
      dataFormat: GLenum(GL_RED),
      dataType: GLenum(GL_UNSIGNED_BYTE),
      data: CGBitmapContextGetData(ctx))
  }
}


class GLTextAtlas {
  let fontName: String
  let textWidths: [Int]
  let chars: Index<Character>
  var pages: [Int:GLTextPage] = [:] // keyed by width.
  
  init(fontName: String, maxTextWidth: Int, charsArray: [Character]) {
    GLTexture_getMaxSize()
    let chars = Index(charsArray)
    self.fontName = fontName
    self.textWidths = [Int](takeWhile(HPOTGen()) { $0 <= 32 })
    self.chars = chars
    self.pages = textWidths.mapToDict() { return ($0, GLTextPage(fontName: fontName, advance: $0, chars: chars)) }
  }
}



