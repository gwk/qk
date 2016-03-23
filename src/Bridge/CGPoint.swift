// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


typealias V2 = CGPoint

extension CGPoint {
  
  init(_ x: CGFloat, _ y: CGFloat) { self.init(x: x, y: y) }

  init(_ v: CGVector) { self.init(x: v.dx, y: v.dy) }
  
  init(_ s: CGSize) { self.init(x: s.w, y: s.h) }

}

func +(a: CGPoint, b: CGSize) -> CGPoint { return CGPoint(a.x + b.w, a.y + b.h) }
func -(a: CGPoint, b: CGSize) -> CGPoint { return CGPoint(a.x - b.w, a.y - b.h) }
