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

  func next() -> U64 {
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

  func next(max: U64) -> U64 {
    // unbiased random.
    let bias_rem = ((U64.max % max) + 1) % max
    let max_unbiased = U64.max - bias_rem
    while true {
      let u = next()
      if u <= max_unbiased {
        return u % max
      }
    }
  }

  func next(min: U64, max: U64) -> U64 {
    if max <= min {
      return min
    }
    return next(max - min) + min
  }

  func next(max: F64) -> F64 {
    let maxU: U64 = 1 << 52 // double precision has 53 digits; back off by one just to be safe.
    let u = next() % maxU // powers of two cannot be biased.
    return F64(u) / F64(maxU)
  }

  func next(min: F64, max: F64) -> F64 {
    if max <= min {
      return min
    }
    return next(max - min) + min
  }
}