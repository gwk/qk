// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGContext {

  var w: Int { return self.width }
  var h: Int { return self.height }
  var bounds: CGRect { return CGRect(0, 0, Flt(w), Flt(h)) }

  func scaleCTM(_ x: Flt, _ y: Flt) { self.scale(x: x, y: y) }
  func translateCTM(_ x: Flt, _ y: Flt) { self.translate(x: x, y: y) }

  func flipCTMHori() {
    translateCTM(Flt(w), 0)
    scaleCTM(-1, 1)
  }

  func setFillColor(r: Flt, g: Flt, b: Flt, a: Flt = 1) {
    self.setFillColor(red: r, green: g, blue: b, alpha: a)
  }

  func setFillColor(_ color: V4S) {
    self.setFillColor(red: Flt(color.r), green: Flt(color.g), blue: Flt(color.b), alpha: Flt(color.a))
  }

  func setFillColor(_ color: V3S) {
    self.setFillColor(red: Flt(color.r), green: Flt(color.g), blue: Flt(color.b), alpha: 1)
  }

  func clearRect(_ rect: CGRect?) {
    self.clear(rect.or(bounds))
  }

  func fillRect(_ rect: CGRect? = nil) {
    self.fill(rect.or(bounds))
  }

  func drawImage(_ image: CGImage, rect: CGRect? = nil) {
    self.draw(in: rect.or(bounds), image: image)
  }

  func createImage() -> CGImage {
    return self.makeImage()!
  }
}
