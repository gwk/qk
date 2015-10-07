// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGPoint {
  
  init(_ x: CGFloat, _ y: CGFloat) { self.init(x: x, y: y) }

  init(_ s: CGSize) { self.init(x: s.w, y: s.h) }
}
