// © 2015 George King. Permission to use this file is granted in license-qk.txt.


protocol DenseEnumType {
  init?(rawValue: Int)
  var rawValue: Int { get }
  static var count: Int { get }
}

extension DenseEnumType {
  static var range: Range<Int> { return 0..<count }
  static var allVariants: [Self] { return range.map { Self(rawValue: $0)! } }
}


struct EnumSetU32<Element: DenseEnumType>: ArrayLiteralConvertible {
  let rawValue: U32

  init() {
    self.rawValue = 0
  }
  
  init(_ element: Element) {
    self.rawValue = 1 << U32(element.rawValue)
  }

  init(arrayLiteral elements: Element...) {
    self.rawValue = elements.reduce(0) { $0 | 1 << U32($1.rawValue) }
  }
}