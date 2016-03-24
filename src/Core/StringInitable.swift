// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


final class StringConversionError: ErrorProtocol {
  let exp: Any.Type
  let string: String

  init(exp: Any.Type, string: String) {
    self.exp = exp
    self.string = string
  }
}

protocol StringInitable {
  init(string: String) throws
}

extension String: StringInitable {
  init(string: String) { self = string }
}

extension Int: StringInitable {
  init(string: String) throws {
    if let i = Int(string) {
      self = i
    } else { throw StringConversionError(exp: Int.self, string: string) }
  }
}

extension UInt: StringInitable {
  init(string: String) throws {
    if let u = UInt(string) {
      self = u
    } else { throw StringConversionError(exp: UInt.self, string: string) }
  }
}

extension Float: StringInitable {
  init(string: String) throws {
    if let f = Float(string) {
      self = f
    } else { throw StringConversionError(exp: Float.self, string: string) }
  }
}

extension Double: StringInitable {
  init(string: String) throws {
    if let d = Double(string) {
      self = d
    } else { throw StringConversionError(exp: Double.self, string: string) }
  }
}

extension Bool: StringInitable {

  init?(_ text: String) {
    switch text {
    case "false": self = false
    case "true":  self = true
    case "False": self = false
    case "True":  self = true
    case "FALSE": self = false
    case "TRUE":  self = true
    default: return nil
    }
  }

  init(string: String) throws {
    if let b = Bool(string) {
      self = b
    } else { throw StringConversionError(exp: Bool.self, string: string) }
  }
}



