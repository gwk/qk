// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


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


func clamp<T: FloatingPointType>(a: T, l: T, h: T) -> T {
  if a < l { return l }
  if a > h { return h }
  return a
}


struct POTGen: GeneratorType {
  typealias Element = Int
  var val: Int
  
  mutating func next() -> Int? {
    let v = val
    val *= 2
    return v
  }
  
  init(val: Int = 1) {
    self.val = val
  }
}


struct HPOTGen: GeneratorType {
  typealias Element = Int
  var val: Int
  var pot: Bool
  
  mutating func next() -> Int? {
    let v = val
    if v < 4 {
      val += 1
      return v
    }
    else if pot {
      val = (val * 3) / 2
    } else {
      val = (val * 4) / 3
    }
    pot = !pot
    return v
  }
  
  init(val: Int = 1) {
    self.val = val
    self.pot = true
  }
}

