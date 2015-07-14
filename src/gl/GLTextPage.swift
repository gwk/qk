// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import CoreGraphics

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


struct GLGlyph: CustomStringConvertible {
  let char: Character
  let adv: Int
  let orig: V2I
  let size: V2I
  let texOrig: V2I
  
  var description: String { return "GLGlyph('\(char)' adv:\(adv) orig:\(orig) size:\(size) texOrig:\(texOrig))" }
}


struct GLTextPage: CustomStringConvertible {
  let font: Font
  let strike: Font.Strike
  let chars: Index<Character>
  let glyphs: [GLGlyph]
  let rows: Int // number of rows of glyphs in the page.
  let size: V2I
  let blockTexCoord: V2I // some point in texel space that is opaque white; used to render missing characters.
  let blockLow: V2I
  let blockHigh: V2I
  let tex: GLTexture
  let img: [U8]
  
  var description: String { return "GLTextPage(\(font.name) metrics:\(metrics) rows:\(rows) size:\(size))" }
  
  var metrics: Font.Metrics { return strike.metrics }
  
  init(font: Font, fontSize: F32, chars: Index<Character>) {
    self.font = font
    self.chars = chars
    self.strike = font.strikeForSize(fontSize, chars: chars.vals)
    
    let wMax = GLTexture_maxSize // maxSize is a bad choice because it may leave lots of empty space left over on the final row.
    var w = 0
    var x = 0 // current pos in image.
    var y = 0
    var glyphs: [GLGlyph] = []
    var rows = 1
    for g in strike.glyphs {
      assert(g.size.x < wMax)
      if x + g.size.x > wMax { // spill to next line.
        x = 0
        y += strike.metrics.maxGlyphHeight
        rows++
      }
      let glyph = GLGlyph(char: g.char, adv: g.adv, orig: g.orig, size: g.size, texOrig: V2I(x, y))
      glyphs.append(glyph)
      x += Int(g.size.x)
      w = max(w, x)
    }
    w = ((w + 7) >> 3) << 3 // round up to nearest word; seems to be required by OpenGL.
    self.size = V2I(w, rows * strike.metrics.maxGlyphHeight)
    var img = [U8](count: Int(size.x * size.y), repeatedValue: 0)
    for (sg, g) in zip(strike.glyphs, glyphs) {
      // TODO: factor out copy?
      for y in 0..<g.size.y {
        let py = g.texOrig.y + y
        for x in 0..<g.size.x {
          let px = g.texOrig.x + x
          let src = sg.img[Int(y * g.size.x + x)]
          img[Int(py) * w + Int(px)] = src
        }
      }
    }
    
    self.glyphs = glyphs
    self.rows = rows
    self.img = img
    blockTexCoord = V2I()
    blockLow = V2I()
    blockHigh = V2I()
    // allocate texture.
    tex = GLTexture()
    tex.update(w: Int(size.x), h: Int(size.y),
      fmt: .L,
      dataFmt: .L,
      dataType: .U8,
      data: img)
    
    #if false
    println("\(description)\n\(lumRepr(img: img, imgSize: size, offset: V2I(), size: size))")
    for g in glyphs {
      println("\(g)\n\(lumRepr(img: img, imgSize: size, offset: g.texOrig, size: g.size))")
    }
    #endif
  }
  
  func glyph(char: Character) -> GLGlyph? {
    if let i = chars.index(char) {
      return glyphs[i]
    } else {
      return nil
    }
  }
}

