// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics
import Foundation


typealias Flt = CGFloat

extension Flt: ArithmeticFloatType {
  var sqr: Flt { return self * self }
  var sqrt: Flt { return Flt(native.sqrt) }
  var ceil: Flt { return Flt(native.ceil) }
  var floor: Flt { return Flt(native.floor) }
  var round: Flt { return Flt(native.round) }
}

extension Flt: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Flt
    } else if let s = json as? NSString {
      if let n = NativeType(s as String) {
        self = Flt(n)
      } else { throw Json.Error.Conversion(exp: Flt.self, json: json) }
    } else { throw Json.Error.UnexpectedType(exp: Flt.self, json: json) }
  }
}

extension Random {
  @warn_unused_result
  func flt(max: Flt) -> Flt {
    return Flt(f64(F64(max)))
  }

  @warn_unused_result
  func flt(min min: Flt, max: Flt) -> Flt {
    return Flt(f64(min: F64(min), max: F64(max)))
  }

}
