// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGVector {

  init(_ dx: Flt, _ dy: Flt) { self.init(dx: dx, dy: dy) }

  var x: Flt { return dx }
  var y: Flt { return dy }
}
