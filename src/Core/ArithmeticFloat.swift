// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Darwin


typealias F32 = Float
typealias F64 = Double


protocol ArithmeticFloat: ArithmeticProtocol, FloatingPoint {
  var sqr: Self { get }
  var sqrt: Self { get }
  var ceil: Self { get }
  var floor: Self { get }
  var round: Self { get }
}


// wrappers around float/double math functions so that we can use overloading properly.
func sqrt_f(f: Float) -> Float { return sqrtf(f) }
func ceil_f(f: Float) -> Float { return ceilf(f) }
func floor_f(f: Float) -> Float { return floorf(f) }
func round_f(f: Float) -> Float { return roundf(f) }

func sqrt_f(d: Double) -> Double { return sqrt(d) }
func ceil_f(d: Double) -> Double { return ceil(d) }
func floor_f(d: Double) -> Double { return floor(d) }
func round_f(d: Double) -> Double { return round(d) }

extension Float: ArithmeticFloat {
  var sqr: Float { return self * self }
  var sqrt: Float { return sqrt_f(self) }
  var ceil: Float { return ceil_f(self) }
  var floor: Float { return floor_f(self) }
  var round: Float { return round_f(self) }
}

extension Double: ArithmeticFloat {
  var sqr: Double { return self * self }
  var sqrt: Double { return sqrt_f(self) }
  var ceil: Double { return ceil_f(self) }
  var floor: Double { return floor_f(self) }
  var round: Double { return round_f(self) }
}


