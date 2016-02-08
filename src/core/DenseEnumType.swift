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
