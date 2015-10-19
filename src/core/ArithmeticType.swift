// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Darwin


typealias Uns = UInt

typealias I8  = Int8
typealias I16 = Int16
typealias I32 = Int32
typealias I64 = Int64

typealias U8  = UInt8
typealias U16 = UInt16
typealias U32 = UInt32
typealias U64 = UInt64

typealias F32 = Float
typealias F64 = Double


protocol ArithmeticType: IntegerLiteralConvertible, Equatable {
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


extension Int: ArithmeticType {}
extension I8: ArithmeticType {}
extension I16: ArithmeticType {}
extension I32: ArithmeticType {}
extension I64: ArithmeticType {}

extension Uns: ArithmeticType {}
extension U8: ArithmeticType {}
extension U16: ArithmeticType {}
extension U32: ArithmeticType {}
extension U64: ArithmeticType {}

extension Float: ArithmeticType {}
extension Double: ArithmeticType {}

// wrappers around float/double math functions so that we can use overloading properly.
func sqrt_f(f: Float) -> Float { return sqrtf(f) }
func ceil_f(f: Float) -> Float { return ceilf(f) }
func floor_f(f: Float) -> Float { return floorf(f) }
func round_f(f: Float) -> Float { return roundf(f) }

func sqrt_f(d: Double) -> Double { return sqrt(d) }
func ceil_f(d: Double) -> Double { return ceil(d) }
func floor_f(d: Double) -> Double { return floor(d) }
func round_f(d: Double) -> Double { return round(d) }

extension Float {
  var sqr: Float { return self * self }
  var sqrt: Float { return sqrt_f(self) }
  var ceil: Float { return ceil_f(self) }
  var floor: Float { return floor_f(self) }
  var round: Float { return round_f(self) }
}

extension Double {
  var sqr: Double { return self * self }
  var sqrt: Double { return sqrt_f(self) }
  var ceil: Double { return ceil_f(self) }
  var floor: Double { return floor_f(self) }
  var round: Double { return round_f(self) }
}


func sum<S: SequenceType where S.Generator.Element: ArithmeticType>(s: S) -> S.Generator.Element {
  typealias E = S.Generator.Element
  return s.reduce(0) { (accum: E, item: E) in return accum + item }
}

func prod<S: SequenceType where S.Generator.Element: ArithmeticType>(s: S) -> S.Generator.Element {
  typealias E = S.Generator.Element
  return s.reduce(1) { (accum: E, item: E) in return accum * item }
}


func clamp<T: ArithmeticType>(a: T, min: T, max: T) -> T {
  if a < min { return min }
  if a > max { return max }
  return a
}


func sign<T: ArithmeticType>(b: Bool) -> T {
  return b ? 1 : -1
}

func sign<T: ArithmeticType>(x: T) -> T {
  if x < 0 { return -1 }
  if x > 0 { return 1 }
  return 0
}
