// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Darwin


extension Array: DefaultInitializable {
  
  var lastIndex: Int? { return count > 0 ? count - 1 : nil }
  
  init(capacity: Int) {
    self = []
    self.reserveCapacity(capacity)
  }

  init<S: Sequence where S.Iterator.Element == Iterator.Element>(join sequences: S...) {
    self = []
    for s in sequences {
      append(contentsOf: s)
    }
  }

  @warn_unused_result
  func optEl(_ index: Int) -> Element? {
    if index >= 0 && index < count {
      return self[index]
    } else {
      return nil
    }
  }

  mutating func removeBySwappingLast(_ index: Int) -> Element {
    let last = self.removeLast()
    if index != count {
      let val = self[index]
      self[index] = last
      return val
    } else {
      return last
    }
  }

  mutating func permuteInPlace(_ random: Random) {
    if isEmpty { return }
    let c = count
    for i in 1..<c {
      let j = c - i
      let k = random.int(j + 1)
      if j == k { continue }
      swap(&self[j], &self[k])
    }
  }

  @warn_unused_result
  func permute(_ random: Random) -> Array {
    var a = self
    a.permuteInPlace(random)
    return a
  }

  func randomElement(_ random: Random) -> Element {
    return self[random.int(count)]
  }
}
