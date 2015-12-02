// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


class Random {
  // XorShift128Plus generator.

  var state0: U64
  var state1: U64

  init(state0: U64 = 0x123456789ABCDEF, state1: U64 = 0x123456789ABCDEF) {
    self.state0 = state0
    self.state1 = state1
  }

  func raw() -> U64 {
    let s1 = state0
    let s0 = state1
    state0 = s0
    let a = s1 ^ (s1 << 23)
    let b = a ^ s0
    let c = b ^ (a >> 17)
    let d = c ^ (s0 >> 26)
    state1 = d &+ s0;
    return state1
  }

  func u64(end: U64) -> U64 {
    // unbiased random.
    let bias_rem = ((U64.max % end) + 1) % end
    let max_unbiased = (U64.max - bias_rem)
    while true {
      let u = raw()
      if u <= max_unbiased {
        return u % end
      }
    }
  }

  func u64(min min: U64, end: U64) -> U64 {
    if min >= end { fatalError("Random.nextU64: min \(min) >= end \(end)") }
    return u64(end - min) + min
  }

  func nextInt(end: Int) -> Int {
    // unbiased random.
    return Int(u64(U64(end)))
  }

  func int(min min: Int, end: Int) -> Int {
    if min >= end { fatalError("Random.nextInt: min \(min) >= end \(end)") }
    let minU = U64(bitPattern: Int64(min))
    let endU = U64(bitPattern: Int64(end))
    let rangeU = endU &- minU
    let randU = u64(rangeU)
    return Int(I64(bitPattern: randU + minU))
  }
  
  func f64(max: F64) -> F64 {
    let endU: U64 = 1 << 52 // double precision has 53 digits; back off by one just to be safe.
    let u = raw() % endU // powers of two cannot be biased.
    return (F64(u) / F64(endU - 1)) * max // divide by maxU = endU - 1 to get float in range [0, 1].
  }

  func f64(min min: F64, max: F64) -> F64 {
    if max <= min {
      return min
    }
    return f64(max - min) + min
  }
}