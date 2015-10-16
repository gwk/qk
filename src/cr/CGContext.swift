// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGContext {

  var w: Int { return CGBitmapContextGetWidth(self) }
  var h: Int { return CGBitmapContextGetHeight(self) }
  var bounds: CGRect { return CGRect(0, 0, Flt(w), Flt(h)) }

  func scaleCTM(x: Flt, _ y: Flt) { CGContextScaleCTM(self, x, y) }
  func translateCTM(x: Flt, _ y: Flt) { CGContextTranslateCTM(self, x, y) }

  func flipHCTM() {
    translateCTM(Flt(w), 0)
    scaleCTM(-1, 1)
  }

  func drawImage(image: CGImage, rect: CGRect? = nil) {
    CGContextDrawImage(self, rect.or(bounds), image)
  }

  func createImage() -> CGImage {
    return CGBitmapContextCreateImage(self)!
  }

}
