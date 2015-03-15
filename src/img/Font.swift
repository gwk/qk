// Copyright 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


func _ftCheck(code: FT_Error, @autoclosure _ message: () -> String = "") {
  if code != 0 {
    let s = message()
    fatalError("freetype error: \(s)\n  code: \(code)")
  }
}


class Font {
  
  struct Metrics: Printable {
    let size: F32
    let isFixedWidth: Bool
    let pxPerEm: Int
    let maxAdv: Int
    let leadTop: Int
    let asc: Int // ascender as defined by the font (positive).
    let desc: Int // descender as defined by the font (positive).
    let leadBottom: Int
    let lineHeight: Int // leadTop + asc + desc + leadBottom.
    let maxGlyphHeight: Int
    let underlinePos: Int
    let underlineThickness: Int
    
    var description: String {
      return "Metrics(size:\(size) isFixedWidth:\(isFixedWidth) pxPerEm:\(pxPerEm) maxAdv:\(maxAdv) leadTop:\(leadTop) asc:\(asc) desc:\(desc) leadBottom:\(leadBottom) lineHeight:\(lineHeight) maxGlyphHeight:\(maxGlyphHeight) underlinePos:\(underlinePos) underlineThickness:\(underlineThickness)"
    }
    
    var baseline: Int { return leadTop + asc } // distance from top to baseline.
  }
  
  struct Glyph: Printable {
    let char: Character
    let adv: Int
    let orig: V2I // from line top-left to glyph img top-left.
    let size: V2I // img dimensions.
    let img: [U8]
    
    var description: String {
      return "Glyph(char:'\(char)' adv:\(adv) orig:\(orig) size:\(size))"
    }
    
    var imgRepr: String {
      return "\(description)\n\(lumRepr(img: img, imgSize: size, offset: V2I(), size: size))"
    }
  }
  
  struct Strike {
    let metrics: Metrics
    let glyphs: [Glyph]
  }
  
  private static let _fontLib: FT_Library = {
    var l: FT_Library = nil
    _ftCheck(FT_Init_FreeType(&l), "failed to load freetype library")
    return l
    }()
  
  private let _face: FT_Face
  
  let name: String
  let isFixedWidth: Bool
  
  deinit {
    _ftCheck(FT_Done_Face(_face))
  }
  
  init(name: String, path: String) {
    self.name = name
    var f: FT_Face = nil
    let fontEC = FT_New_Face(Font._fontLib, path, 0, &f)
    check(fontEC != FT_Error(FT_Err_Unknown_File_Format), "unsupported font format: \(path)")
    _ftCheck(fontEC, "could not read font: \(path)")
    _face = f
    isFixedWidth = Bool(_face.memory.face_flags & FT_FACE_FLAG_FIXED_WIDTH)
    //font.face_flags & FT_FACE_FLAG_KERNING FT_Get_Kerning
    let fc = _face.memory
    if fc.num_fixed_sizes > 0 {
      println("fixed sizes: \(fc.num_fixed_sizes)")
      for i in UnsafeBufferPointer(start: fc.available_sizes, count: Int(fc.num_fixed_sizes)) {
        println("  \(i)")
      }
    }
  }
  
  func strikeForSize(size: F32, chars: [Character]) -> Strike {
    
    func toInt<T: IntegerType>(val: T) -> Int { // convert the 26.6 fixed format to an Int, rounding up.
      return (Int(val.toIntMax()) + 63) / 64
    }
    
    _ftCheck(FT_Set_Pixel_Sizes(_face, 0, FT_UInt(size)))
    let f = _face.memory
    let m = f.size.memory.metrics
    assert(m.x_ppem == m.y_ppem)
    
    let lineHeight = toInt(m.height)
    let asc = toInt(m.ascender)
    let desc = -toInt(m.descender)
    let lead = lineHeight - (asc + desc)
    let leadTop = lead / 2 // TODO: should top or bottom get the odd lead px?
    let leadBottom = lead - leadTop
    let baseline = leadTop + asc
    
    // note: using chars.map() caused segfault in swift 1.2.
    var maxH = 0
    var glyphs: [Glyph] = []
    for c in chars {
      let glyphIndex = FT_Get_Char_Index(self._face, FT_ULong(c.code.value))
      _ftCheck(FT_Load_Glyph(self._face, glyphIndex, FT_Int32(FT_LOAD_RENDER)))
      
      let g = f.glyph.memory
      let w = Int(g.bitmap.width)
      let h = Int(g.bitmap.rows)
      maxH = max(maxH, h)
      
      let glyph = Glyph(
        char: c,
        adv: toInt(g.advance.x),
        orig: V2I(Int(g.bitmap_left), baseline - Int(g.bitmap_top)),
        size: V2I(w, h),
        img: Array(UnsafeBufferPointer(start: g.bitmap.buffer, count: w * h)))
      glyphs.append(glyph)
    }
    let metrics = Metrics(
      size: size,
      isFixedWidth: isFixedWidth,
      pxPerEm: Int(m.x_ppem),
      maxAdv: toInt(m.max_advance),
      leadTop: leadTop,
      asc: asc,
      desc: desc,
      leadBottom: leadBottom,
      lineHeight: lineHeight,
      maxGlyphHeight: maxH,
      underlinePos: toInt(f.underline_position),
      underlineThickness: toInt(f.underline_thickness))
    
return Strike(metrics: metrics, glyphs: glyphs)
  }
}


extension NSBundle {
  
  class func fontNamed(name: String) -> Font {
    let p = resPath(name)
    return Font(name: name, path: p)
  }
}

