// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


typealias Flt = CGFloat

extension Flt: ArithmeticType {
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
      if let n = Flt(s as String) {
        self = n
      } else { throw Json.Error.Conversion(exp: Flt.self, json: json) }
    } else { throw Json.Error.UnexpectedType(exp: Flt.self, json: json) }
  }
}
