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

  convenience init(arc4Seeded: Bool) {
    var states: [U64] = [0x123456789ABCDEF, 0x123456789ABCDEF]
    if arc4Seeded {
      states.withUnsafeMutableBufferPointer { arc4random_buf($0.baseAddress, 16) }
    }
    self.init(state0: states[0], state1: states[1])
  }

  @warn_unused_result
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

  @warn_unused_result
  func u64(_ end: U64) -> U64 {
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

  @warn_unused_result
  func u64(min: U64, end: U64) -> U64 {
    if min >= end { fatalError("Random.nextU64: min \(min) >= end \(end)") }
    return u64(end - min) + min
  }

  @warn_unused_result
  func int(_ end: Int) -> Int {
    // unbiased random.
    return Int(u64(U64(end)))
  }

  @warn_unused_result
  func int(min: Int, end: Int) -> Int {
    if min >= end { fatalError("Random.nextInt: min \(min) >= end \(end)") }
    let minU = U64(bitPattern: Int64(min))
    let endU = U64(bitPattern: Int64(end))
    let rangeU = endU &- minU
    let randU = u64(rangeU)
    return Int(I64(bitPattern: randU + minU))
  }
  
  @warn_unused_result
  func f64(_ max: F64) -> F64 {
    let endU: U64 = 1 << 52 // double precision has 53 digits; back off by one just to be safe.
    let u = raw() % endU // powers of two cannot be biased.
    return (F64(u) / F64(endU - 1)) * max // divide by maxU = endU - 1 to get float in range [0, 1].
  }

  @warn_unused_result
  func f64(min: F64, max: F64) -> F64 {
    if max <= min {
      return min
    }
    return f64(max - min) + min
  }

  @warn_unused_result
  func bool() -> Bool {
    return raw() >= 0x8000000000000000
  }
}
