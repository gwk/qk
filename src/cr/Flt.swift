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

