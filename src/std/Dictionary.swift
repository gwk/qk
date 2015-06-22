// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension Dictionary {
  
  func contains(key: Key) -> Bool {
    switch self[key] {
    case .None: return false
    case .Some: return true
    }
  }
}

func valsSortedByKey<K: Comparable, V>(dict: [K: V]) -> [V] {
  let s = dict.sort {
    (a: (k: K, v: V), b: (k: K, v: V)) in
    return a.k < b.k
  }
  return s.map() {
    e in
    let (k, v) = e
    return v
  }
}
