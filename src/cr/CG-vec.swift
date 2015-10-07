// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension V2S {
  init(_ p: CGPoint) { self.init(F32(p.x), F32(p.y)) }
  init(_ s: CGSize) { self.init(F32(s.width), F32(s.height)) }
}