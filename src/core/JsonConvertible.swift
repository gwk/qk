// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonConvertible {
  init(json: JsonType) throws
}

extension Int: JsonConvertible {
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

extension UInt: JsonConvertible {
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

extension Float: JsonConvertible {
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

extension Double: JsonConvertible {
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

extension Bool: JsonConvertible {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Bool
    } else if let s = json as? NSString {
      guard let b = Bool(s as String) else { throw Json.Error.Conversion(exp: Bool.self, json: json) }
      self = b
    } else { throw Json.Error.UnexpectedType(exp: Bool.self, json: json) }
  }
}

extension String: JsonConvertible {
  init(json: JsonType) throws {
    if let s = json as? String {
      self = s
    } else { throw Json.Error.UnexpectedType(exp: String.self, json: json) }
  }
}

extension Array: JsonConvertible {
  // note: the signature should include `where Element: JsonConvertible`.
  // swift 2.1b3 does not support this.
  init(json: JsonType) throws {
    guard let E = Element.self as? JsonConvertible.Type else { fatalError("Array.Element type \(Element.self) is not JsonConvertible") }
    guard let array = json as? [JsonType] else { throw Json.Error.UnexpectedType(exp: [Element].self, json: json) }
    self = try array.map() { try E.init(json: $0) as! Element }
  }
}

extension Dictionary: JsonConvertible {
  // note: the signature should include `where Key: StringConvertible, Value: JsonConvertible`.
  // swift 2.1b3 does not support this.
  init(json: JsonType) throws {
    guard let K = Key.self as? StringConvertible.Type else { fatalError("Dictionary.Key type \(Key.self) is not StringConvertible") }
    guard let V = Value.self as? JsonConvertible.Type else { fatalError("Dictionary.Value type \(Value.self) is not JsonConvertible") }
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
