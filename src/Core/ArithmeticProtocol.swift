// © 2014 George King. Permission to use this file is granted in license-qk.txt.


typealias Uns = UInt

typealias I8  = Int8
typealias I16 = Int16
typealias I32 = Int32
typealias I64 = Int64

typealias U8  = UInt8
typealias U16 = UInt16
typealias U32 = UInt32
typealias U64 = UInt64


protocol ArithmeticProtocol: IntegerLiteralConvertible, Equatable, Comparable {
  func +(l: Self, r: Self) -> Self
  func -(l: Self, r: Self) -> Self
  func *(l: Self, r: Self) -> Self
  func /(l: Self, r: Self) -> Self
  func %(l: Self, r: Self) -> Self
  func <(l: Self, r: Self) -> Bool
  func >(l: Self, r: Self) -> Bool
  func <=(l: Self, r: Self) -> Bool
  func >=(l: Self, r: Self) -> Bool
}

extension Int: ArithmeticProtocol {}
extension I8: ArithmeticProtocol {}
extension I16: ArithmeticProtocol {}
extension I32: ArithmeticProtocol {}
extension I64: ArithmeticProtocol {}

extension Uns: ArithmeticProtocol {}
extension U8: ArithmeticProtocol {}
extension U16: ArithmeticProtocol {}
extension U32: ArithmeticProtocol {}
extension U64: ArithmeticProtocol {}

@warn_unused_result
func clamp<T: ArithmeticProtocol>(_ a: T, min: T, max: T) -> T {
  if a < min { return min }
  if a > max { return max }
  return a
}

@warn_unused_result
func sign<T: ArithmeticProtocol>(_ b: Bool) -> T {
  return b ? 1 : -1
}

@warn_unused_result
func sign<T: ArithmeticProtocol>(_ x: T) -> T {
  if x < 0 { return -1 }
  if x > 0 { return 1 }
  return 0
}


extension Sequence where Iterator.Element: ArithmeticProtocol {

  @warn_unused_result
  func sum() -> Iterator.Element {
    return reduce(0) { (accum: Iterator.Element, item: Iterator.Element) in return accum + item }
  }

  @warn_unused_result
  func prod() -> Iterator.Element {
    return reduce(1) { (accum: Iterator.Element, item: Iterator.Element) in return accum * item }
  }
}

