// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Darwin


extension Array: DefaultInitializable {
  
  var lastIndex: Int? { return count > 0 ? count - 1 : nil }
  
  init(capacity: Int) {
    self = []
    self.reserveCapacity(capacity)
  }

  init<S: SequenceType where S.Generator.Element == Generator.Element>(join sequences: S...) {
    self = []
    for s in sequences {
      appendContentsOf(s)
    }
  }

  func get(index: Int) -> Element? {
    if index >= 0 && index < count {
      return self[index]
    } else {
      return nil
    }
  }

  mutating func removeBySwappingLast(index: Int) -> Element {
    let last = self.removeLast()
    if index != count {
      let val = self[index]
      self[index] = last
      return val
    } else {
      return last
    }
  }

  mutating func permuteInPlace(random: Random) {
    let c = count
    for i in 1..<c {
      let j = c - i
      let k = random.nextInt(j + 1)
      if j == k { continue }
      swap(&self[j], &self[k])
    }
  }

  func permute(random: Random) -> Array {
    var a = self
    a.permuteInPlace(random)
    return a
  }
}
