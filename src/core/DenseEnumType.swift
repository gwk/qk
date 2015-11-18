// © 2015 George King. Permission to use this file is granted in license-qk.txt.


protocol DenseEnumType {
  init?(rawValue: Int)
  var rawValue: Int { get }
  static var count: Int { get }
}

extension DenseEnumType {
  static var all: [Self] { return (0..<count).map { Self(rawValue: $0)! } }
}
