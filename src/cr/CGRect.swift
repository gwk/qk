// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import CoreGraphics


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
  
  var c: CGPoint {
    get { return CGPoint(o.x + (0.5 * s.w), o.y + (0.5 * s.h)) }
    set { o = CGPoint(newValue.x - (0.5 * s.w), newValue.y - (0.5 * s.h)) }
  }
  
  var x: Flt {
    get { return o.x }
    set { o.x = newValue }
  }
  
  var y: Flt {
    get { return o.y }
    set { o.y = newValue }
  }
  
  var w: Flt {
    get { return s.w }
    set { s.w = newValue }
  }
  
  var h: Flt {
    get { return s.h }
    set { s.h = newValue }
  }
  
  var r: Flt {
    get { return x + w }
    set { x = newValue - w }
  }
  
  var b: Flt {
    get { return y + h }
    set { y = newValue - h }
  }
  
  func inset(dx dx: Flt, dy: Flt) -> CGRect {
    return CGRectInset(self, dx, dy)
  }
}

let frameInit = CGRect(0, 0, 256, 256) // large, weird size to make it obvious when we forget to specify layout constraints.
