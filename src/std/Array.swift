// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension Array {

  init(capacity: Int) {
    self = []
    self.reserveCapacity(capacity)
  }

  func mapEnum<U>(transform: (Int, T) -> U) -> [U] {
    var a = [U](capacity:self.count)
    for (i, e) in enumerate(self) {
      a[i] = transform(i, e)
    }
    return a
  }
  
  func mapToDict<K, V>(transform: (T) -> (K, V)) -> [K:V] {
    var d = [K:V]()
    for e in self {
      let (k, v) = transform(e)
      d[k] = v
    }
    return d
  }
  
  func mapEnumToDict<K, V>(transform: (Int, T) -> (K, V)) -> [K:V] {
    var d = [K:V]()
    for (i, e) in enumerate(self) {
      let (k, v) = transform(i, e)
      d[k] = v
    }
    return d
  }
}
