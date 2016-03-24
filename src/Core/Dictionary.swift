// © 2014 George King. Permission to use this file is granted in license-qk.txt.


extension Dictionary {
  
  @warn_unused_result
  func contains(key: Key) -> Bool {
    return self[key] != nil
  }

  mutating func insertNew(key: Key, value: Value) {
    assert(!contains(key), "insertNew: key already inserted: \(key); value: \(value)")
    self[key] = value
  }

  mutating func updateExisting(key: Key, value: Value) {
    assert(contains(key), "updateExisting: key not yet inserted: \(key); value: \(value)")
    self[key] = value
  }

  @warn_unused_result
  func mapVals<V>(@noescape transform: (Value) throws -> V) rethrows -> [Key:V] {
    var d: [Key:V] = [:]
    for (k, v) in self {
      d[k] = try transform(v)
    }
    return d
  }

  @warn_unused_result
  mutating func getDefault(key: Key, @noescape dflt: () -> Value) -> Value {
    if let v = self[key] {
      return v
    } else {
      let v = dflt()
      self[key] = v
      return v
    }
  }

  @warn_unused_result
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

  @warn_unused_result
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
    return sorted() {
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


// TODO: remove in favor of ArrayDict class?

protocol AppendableValueType {
  associatedtype Element
  mutating func append(element: Element)
}


extension Array: AppendableValueType {}

extension Dictionary where Value: AppendableValueType, Value: DefaultInitializable {

  mutating func appendToValue(key: Key, _ el: Value.Element) {
    var v: Value
    if let ov = removeValue(forKey: key) {
      v = ov
    } else {
      v = Value()
    }
    v.append(el)
    self[key] = v
  }
}
