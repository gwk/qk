// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonInitable {
  init(json: JsonType) throws
}

extension JsonType {
  func conv<T: JsonInitable>() throws -> T { return try T(json: self) }
}

extension Int: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Int
    } else if let s = json as? NSString {
      if let n = Int(s as String) {
        self = n
      } else { throw Json.Error.conversion(exp: Int.self, json: json) }
    } else { throw Json.Error.unexpectedType(exp: Int.self, json: json) }
  }
}

extension UInt: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as UInt
    } else if let s = json as? NSString {
      if let n = UInt(s as String) {
        self = n
      } else { throw Json.Error.conversion(exp: UInt.self, json: json) }
    } else { throw Json.Error.unexpectedType(exp: UInt.self, json: json) }
  }
}

extension U8: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = U8(n as UInt)
    } else if let s = json as? NSString {
      if let n = UInt(s as String) {
        if n > UInt(U8.max) { throw Json.Error.conversion(exp: U8.self, json: json) }
        self = U8(n)
      } else { throw Json.Error.conversion(exp: UInt.self, json: json) }
    } else { throw Json.Error.unexpectedType(exp: UInt.self, json: json) }
  }
}

extension Float: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Float
    } else if let s = json as? NSString {
      if let n = Float(s as String) {
        self = n
      } else { throw Json.Error.conversion(exp: Float.self, json: json) }
    } else { throw Json.Error.unexpectedType(exp: Float.self, json: json) }
  }
}

extension Double: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Double
    } else if let s = json as? NSString {
      if let n = Double(s as String) {
        self = n
      } else { throw Json.Error.conversion(exp: Double.self, json: json) }
    } else { throw Json.Error.unexpectedType(exp: Double.self, json: json) }
  }
}

extension Bool: JsonInitable {
  init(json: JsonType) throws {
    if let n = json as? NSNumber {
      self = n as Bool
    } else if let s = json as? NSString {
      guard let b = Bool(s as String) else { throw Json.Error.conversion(exp: Bool.self, json: json) }
      self = b
    } else { throw Json.Error.unexpectedType(exp: Bool.self, json: json) }
  }
}

extension String: JsonInitable {
  init(json: JsonType) throws {
    if let s = json as? String {
      self = s
    } else { throw Json.Error.unexpectedType(exp: String.self, json: json) }
  }
}
