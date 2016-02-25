// © 2015 George King. Permission to use this file is granted in license-qk.txt.


protocol PixelType {
  associatedtype Scalar
  static var numComponents: Int { get }
}

extension U8: PixelType {
  typealias Scalar = U8
  static var numComponents: Int { return 1 }
}

extension F32: PixelType {
  typealias Scalar = F32
  static var numComponents: Int { return 1 }
}

extension V2U8: PixelType {
  static var numComponents: Int { return 2 }
}

extension V3U8: PixelType {
  static var numComponents: Int { return 3 }
}

extension V4U8: PixelType {
  static var numComponents: Int { return 4 }
}

extension V2S: PixelType {
  static var numComponents: Int { return 2 }
}

extension V3S: PixelType {
  static var numComponents: Int { return 3 }
}

extension V4S: PixelType {
  static var numComponents: Int { return 4 }
}
