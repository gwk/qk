// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import CoreGraphics


typealias Flt = CGFloat

extension Flt: ArithmeticType {
  var sqr: Flt { return self * self }
  var sqrt: Flt { return Flt(native.sqrt) }
  var ceil: Flt { return Flt(native.ceil) }
  var floor: Flt { return Flt(native.floor) }
  var round: Flt { return Flt(native.round) }
}


// note: see V2-generated.swift for generated extensions.
typealias V2 = CGPoint

extension CGPoint {
  init(_ s: CGSize) { self.init(s.w, s.h) }
}


extension CGSize {

  init(_ w: Flt, _ h: Flt) { self.init(width: w, height: h) }
  
  static let zero = CGSize.zeroSize
  
  var w: Flt {
    get { return width }
    set { width = newValue }
  }

  var h: Flt {
    get { return height }
    set { height = newValue }
  }
  
  var v: V2 { return V2(w, h); }
  var vs: V2S { return V2S(F32(w), F32(h)); }
}


extension CGRect {
  
  init(_ x: Flt, _ y: Flt, _ w: Flt, _ h: Flt) { self.init(x: x, y: y, width: w, height: h) }

  init(x: Flt, y: Flt, r: Flt, b: Flt) { self.init(x, y, r - x, b - y) }

  init(_ w: Flt, _ h: Flt) { self.init(0, 0, w, h) }
  
  init(_ o: CGPoint, _ s: CGSize) { self.init(o.x, o.y, s.w, s.h) }

  init(c: CGPoint, s: CGSize) { self.init(c.x - s.w * 0.5, c.y - s.h * 0.5, s.w, s.h) }
  
  init(_ s: CGSize) { self.init(0, 0, s.w, s.h) }
  
  init(p0: CGPoint, p1: CGPoint) {
    var x, y, w, h: Flt
    if p0.x < p1.x {
      x = p0.x
      w = p1.x - p0.x
    } else {
      x = p1.x
      w = p0.x - p1.x
    }
    if p0.y < p1.y {
      y = p0.y
      h = p1.y - p0.y
    } else {
      y = p1.y
      h = p0.y - p1.y
    }
    self.init(x, y, w, h)
  }
  
  static let zero = CGRect.zeroRect
  
  var o: CGPoint {
    get { return origin }
    set { origin = newValue }
  }
  
  var s: CGSize {
    get { return size }
    set { size = newValue }
  }
  
  var x: Flt {
    get { return o.x }
    set { o = CGPoint(newValue, o.y) }
  }
  
  var y: Flt {
    get { return o.y }
    set { o = CGPoint(o.x, newValue) }
  }
  
  var w: Flt {
    get { return s.w }
    set { s = CGSize(newValue, s.h) }
  }
  
  var h: Flt {
    get { return s.h }
    set { s = CGSize(s.w, newValue) }
  }
  
  var r: Flt {
    get { return x + w }
    set { x = newValue - w }
  }
  
  var b: Flt {
    get { return y + h }
    set { y = newValue - h }
  }
  
  func inset(#dx: Flt, dy: Flt) -> CGRect {
    return CGRectInset(self, dx, dy)
  }
}

let frameInit = CGRect(0, 0, 256, 256) // large, weird size to make it obvious when we forget to specify layout constraints.

