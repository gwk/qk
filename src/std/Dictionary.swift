// © 2014 George King. Permission to use this file is granted in license-qk.txt.


extension Dictionary {
  
  func contains(key: Key) -> Bool {
    return self[key] != nil
  }

  func mapVals<V>(transform: (Value) -> V) -> [Key:V] {
    var d: [Key:V] = [:]
    for (k, v) in self {
      d[k] = transform(v)
    }
    return d
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

  mutating func getDefault(key: Key, dflt: Value) -> Value {
    if let v = self[key] {
      return v
    } else {
      let v = dflt
      self[key] = v
      return v
    }
  }
}


extension Dictionary where Value: DefaultInitializable {
  mutating func getDefault(key: Key) -> Value {
    if let v = self[key] {
      return v
    } else {
      let v = Value()
      self[key] = v
      return v
    }
  }
}


extension Dictionary where Key: Comparable {

  var pairsSortedByKey: [(Key, Value)] {
    return sort() {
      (a: (k: Key, v: Value), b: (k: Key, v: Value)) in
      return a.k < b.k
    }
  }

  var valsSortedByKey: [Value] {
    return pairsSortedByKey.map() {
      (_, v) in return v
    }
  }
}


protocol AppendableValueType {
  typealias Element
  mutating func append(element: Element)
}

extension Array: AppendableValueType {}

extension Dictionary where Value: AppendableValueType, Value: DefaultInitializable {
  mutating func appendToVal(key: Key, _ el: Value.Element) {
    var v: Value
    if let ov = removeValueForKey(key) {
      v = ov
    } else {
      v = Value()
    }
    v.append(el)
    self[key] = v
  }
}