// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import CoreGraphics

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


class GLTextAtlas {
  let font: Font
  let chars: Index<Character>
  let sizes: [F32]
  var pages: [F32:GLTextPage] = [:] // keyed by font size.
  
  init(fontName: String, maxSize: F32, maxPxPerPt: F32, charsArray: [Character]) {
    GLTexture_getMaxSize()
    let chars = Index(charsArray)
    var sizes:[F32] = []
    for i in HPOTSeq() {
      let f = F32(i)
      if f > maxSize * maxPxPerPt { break }
      sizes.append(f)
    }
    self.font = NSBundle.fontNamed(fontName)
    self.chars = chars
    self.sizes = sizes
    self.pages = mapToDict(sizes) { return ($0, GLTextPage(font: self.font, fontSize: $0, chars: chars)) }
  }
  
  func page(size: F32, pxPerPt: F32) -> GLTextPage {
    return pages[size * pxPerPt]!
  }
}
