// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import CoreGraphics


typealias Flt = CGFloat
typealias V2 = CGPoint


extension Flt: ArithmeticType {
  var sqr: Flt { return self * self }
  var sqrt: Flt { return Flt(native.sqrt) }
  var ceil: Flt { return Flt(native.ceil) }
  var floor: Flt { return Flt(native.floor) }
  var round: Flt { return Flt(native.round) }
}


extension CGPoint: Printable {
  
  init(_ x: Flt, _ y: Flt) { self.init(x: x, y: y) }
  
  init(_ s: CGSize) { self.init(s.w, s.h) }

  static let zero = CGPoint.zeroPoint

  public var description: String { return "V2(\(x), \(y))" }
  var v32: V2F32 { return V2F32(F32(x), F32(y)); }
  var len: Flt { return (x.sqr + y.sqr).sqrt }
  var norm: V2 { return self / self.len }
  var clampToUnit: V2 { return V2(clamp(x, 0, 1), clamp(y, 0, 1)) }
}

func +(a: V2, b: V2) -> V2 { return V2(a.x + b.x, a.y + b.y) }
func -(a: V2, b: V2) -> V2 { return V2(a.x - b.x, a.y - b.y) }
func *(a: V2, b: V2) -> V2 { return V2(a.x * b.x, a.y * b.y) }
func /(a: V2, b: V2) -> V2 { return V2(a.x / b.x, a.y / b.y) }
func +(a: V2, s: Flt) -> V2 { return V2(a.x + s, a.y + s) }
func -(a: V2, s: Flt) -> V2 { return V2(a.x - s, a.y - s) }
func *(a: V2, s: Flt) -> V2 { return V2(a.x * s, a.y * s) }
func /(a: V2, s: Flt) -> V2 { return V2(a.x / s, a.y / s) }


extension CGSize {

  init(_ w: Flt, _ h: Flt) { self.init(width: w, height: h) }
  
  static let zero = CGSize.zeroSize
  
  var w: Flt {
    get { return width }
    set(w) { width = w }
  }

  var h: Flt {
    get { return height }
    set(h) { height = h }
  }
  
  var v: V2 { return V2(w, h); }
  var v32: V2F32 { return V2F32(F32(w), F32(h)); }
}


extension CGRect {
  
  init(_ x: Flt, _ y: Flt, _ w: Flt, _ h: Flt) { self.init(x: x, y: y, width: w, height: h) }

  init(x: Flt, y: Flt, r: Flt, b: Flt) { self.init(x: x, y: y, width: r - x, height: b - y) }

  init(_ w: Flt, _ h: Flt) { self.init(0, 0, w, h) }
  
  init(_ o: CGPoint, _ s: CGSize) { self.init(o.x, o.y, s.w, s.h) }

  init(_ s: CGSize) { self.init(0, 0, s.w, s.h) }
  
  static let zero = CGRect.zeroRect
  
  var o: CGPoint {
    get { return origin }
    set(o) { origin = o }
  }
  
  var s: CGSize {
    get { return size }
    set(s) { size = s }
  }
  
  var x: Flt {
    get { return o.x }
    set(x) { o = CGPoint(x, o.y) }
  }
  
  var y: Flt {
    get { return o.y }
    set(y) { o = CGPoint(o.x, y) }
  }
  
  var w: Flt {
    get { return s.w }
    set(w) { s = CGSize(w, s.h) }
  }
  
  var h: Flt {
    get { return s.h }
    set(h) { s = CGSize(s.w, h) }
  }
  
  var r: Flt {
    get { return x + w }
    set { x = newValue - w }
  }
  
  var b: Flt {
    get { return y + h }
    set { y = newValue - h }
  }
  
  func inset(dx: Flt, dy: Flt) -> CGRect {
    return CGRectInset(self, dx, dy)
  }
}

let frameInit = CGRect(0, 0, 256, 256) // large, weird size to make it obvious when we forget to specify layout constraints.

