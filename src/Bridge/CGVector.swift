// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGVector {

  init(_ dx: Flt, _ dy: Flt) { self.init(dx: dx, dy: dy) }

  init(_ v: V2) { self.init(dx: v.x, dy: v.y) }

  var x: Flt {
    get { return dx }
    set { dx = newValue }
  }

  var y: Flt {
    get { return dy }
    set { dy = newValue }
  }
}
