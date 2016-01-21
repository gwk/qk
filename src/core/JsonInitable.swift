// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonInitable {
  init(json: JsonType) throws
}

extension Int: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Int
    } else if let s = json as? NSString {
      if let n = Int(s as String) {
        self = n
      } else { throw Json.Error.Conversion(exp: Int.self, json: json) }
    } else { throw Json.Error.UnexpectedType(exp: Int.self, json: json) }
  }
}

extension UInt: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as UInt
    } else if let s = json as? NSString {
      if let n = UInt(s as String) {
        self = n
      } else { throw Json.Error.Conversion(exp: UInt.self, json: json) }
    } else { throw Json.Error.UnexpectedType(exp: UInt.self, json: json) }
  }
}

extension U8: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = U8(n as UInt)
    } else if let s = json as? NSString {
      if let n = UInt(s as String) {
        if n > UInt(U8.max) { throw Json.Error.Conversion(exp: U8.self, json: json) }
        self = U8(n)
      } else { throw Json.Error.Conversion(exp: UInt.self, json: json) }
    } else { throw Json.Error.UnexpectedType(exp: UInt.self, json: json) }
  }
}

extension Float: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Float
    } else if let s = json as? NSString {
      if let n = Float(s as String) {
        self = n
      } else { throw Json.Error.Conversion(exp: Float.self, json: json) }
    } else { throw Json.Error.UnexpectedType(exp: Float.self, json: json) }
  }
}

extension Double: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Double
    } else if let s = json as? NSString {
      if let n = Double(s as String) {
        self = n
      } else { throw Json.Error.Conversion(exp: Double.self, json: json) }
    } else { throw Json.Error.UnexpectedType(exp: Double.self, json: json) }
  }
}

extension Bool: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Bool
    } else if let s = json as? NSString {
      guard let b = Bool(s as String) else { throw Json.Error.Conversion(exp: Bool.self, json: json) }
      self = b
    } else { throw Json.Error.UnexpectedType(exp: Bool.self, json: json) }
  }
}

extension String: JsonInitable {
  init(json: JsonType) throws {
    if let s = json as? String {
      self = s
    } else { throw Json.Error.UnexpectedType(exp: String.self, json: json) }
  }
}

extension Array: JsonInitable {
  // note: the signature should include `where Generator.Element: JsonInitable`.
  // swift 2.1.1 does not support this.
  init(json: JsonType) throws {
    guard let E = Element.self as? JsonInitable.Type else { fatalError("Array.Element type \(Element.self) is not JsonInitable") }
    guard let array = json as? [JsonType] else { throw Json.Error.UnexpectedType(exp: [Element].self, json: json) }
    self = try array.map() { try E.init(json: $0) as! Element }
  }
}

extension Dictionary: JsonInitable {
  // note: the signature should include `where Key: StringInitable, Value: JsonInitable`.
  // swift 2.1.1 does not support this.
  init(json: JsonType) throws {
    guard let K = Key.self as? StringInitable.Type else { fatalError("Dictionary.Key type \(Key.self) is not StringInitable") }
    guard let V = Value.self as? JsonInitable.Type else { fatalError("Dictionary.Value type \(Value.self) is not JsonInitable") }
    guard let dict = json as? [String:JsonType] else { throw Json.Error.UnexpectedType(exp: [Key:Value].self, json: json) }
    var d: [Key:Value] = [:]
    for (k, v) in dict {
      let key = try K.init(string: k) as! Key
      let val = try V.init(json: v) as! Value
      d[key] = val
    }
    self = d
  }
}
