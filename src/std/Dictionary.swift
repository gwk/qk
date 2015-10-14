// © 2014 George King. Permission to use this file is granted in license-qk.txt.


extension Dictionary {
  
  func contains(key: Key) -> Bool {
    return self[key] != nil
  }
  
  mutating func getDefault(key: Key, dflt: () -> Value) -> Value {
    if let v = self[key] {
      return v
    } else {
      let v = dflt()
      self[key] = v
      return v
    }
  }
}


extension Dictionary where Key: Comparable {
  var valsSortedByKey: [Value] {
    let s = sort {
      (a: (k: Key, v: Value), b: (k: Key, v: Value)) in
      return a.k < b.k
    }
    return s.map() {
      (_, v) in return v
    }
  }
}