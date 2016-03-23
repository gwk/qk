// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGContext {

  var w: Int { return CGBitmapContextGetWidth(self) }
  var h: Int { return CGBitmapContextGetHeight(self) }
  var bounds: CGRect { return CGRect(0, 0, Flt(w), Flt(h)) }

  func scaleCTM(x: Flt, _ y: Flt) { CGContextScaleCTM(self, x, y) }
  func translateCTM(x: Flt, _ y: Flt) { CGContextTranslateCTM(self, x, y) }

  func flipCTMHori() {
    translateCTM(Flt(w), 0)
    scaleCTM(-1, 1)
  }

  func setFillColor(r r: Flt, g: Flt, b: Flt, a: Flt = 1) {
    CGContextSetRGBFillColor(self, r, g, b, a)
  }

  func setFillColor(color: V4S) {
    CGContextSetRGBFillColor(self, Flt(color.r), Flt(color.g), Flt(color.b), Flt(color.a))
  }

  func setFillColor(color: V3S) {
    CGContextSetRGBFillColor(self, Flt(color.r), Flt(color.g), Flt(color.b), 1)
  }

  func clearRect(rect: CGRect?) {
    CGContextClearRect(self, rect.or(bounds))
  }

  func fillRect(rect: CGRect? = nil) {
    CGContextFillRect(self, rect.or(bounds))
  }

  func drawImage(image: CGImage, rect: CGRect? = nil) {
    CGContextDrawImage(self, rect.or(bounds), image)
  }

  func createImage() -> CGImage {
    return CGBitmapContextCreateImage(self)!
  }
}
