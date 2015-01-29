// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension Array {
  
  var lastIndex: Int? { return count > 0 ? count - 1 : nil }
  
  init(capacity: Int) {
    self = []
    self.reserveCapacity(capacity)
  }

  func mapEnum<U>(transform: (Int, T) -> U) -> [U] {
    var a = [U](capacity:self.count)
    for (i, e) in enumerate(self) {
      a.append(transform(i, e))
    }
    return a
  }
}
