// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension SequenceType {

  func group<K: Hashable>(fn: (Generator.Element) -> K?) -> [K:[Generator.Element]] {
    var d: [K:[Generator.Element]] = [:]
    for e in self {
      if let k = fn(e) {
        d.appendToVal(k, e)
      }
    }
    return d
  }

  func filterMap<E>(transform: ((Generator.Element) -> E?)) -> [E] {
    var a: [E] = []
    for e in self {
      if let t = transform(e) {
        a.append(t)
      }
    }
    return a
  }

  func mapToDict<K: Hashable, V>(transform: (Generator.Element) -> (K, V)) -> [K:V] {
    var d: [K:V] = [:]
    for e in self {
      let (k, v) = transform(e)
      d[k] = v
    }
    return d
  }

  func mapUniquesToDict<K: Hashable, V>(transform: (Generator.Element) -> (K, V)) throws -> [K:V] {
    var d: [K:V] = [:]
    for e in self {
      let (k, v) = transform(e)
      if d.contains(k) { throw DuplicateKeyError(key: k, existing: d[k], incoming: v) }
      d[k] = v
    }
    return d
  }

  func all(predicate: (Generator.Element) -> Bool) -> Bool {
    for e in self {
      if !predicate(e) {
        return false
      }
    }
    return true
  }

  func any(predicate: (Generator.Element) -> Bool) -> Bool {
    for e in self {
      if predicate(e) {
        return true
      }
    }
    return false
  }
}


extension SequenceType where Generator.Element: Equatable {

  func replace(query: Generator.Element, with: Generator.Element) -> [Generator.Element] {
    var result: [Generator.Element] = []
    for e in self {
      if e == query {
        result.append(with)
      } else {
        result.append(e)
      }
    }
    return result
  }

  func replace<Q: CollectionType, W: CollectionType where Q.Generator.Element == Generator.Element, W.Generator.Element == Generator.Element>(query: Q, with: W) -> [Generator.Element] {
    if query.isEmpty {
      return Array(self)
    }
    var buffer: [Generator.Element] = []
    var result: [Generator.Element] = []
    var i = query.startIndex
    for e in self {
      if e == query[i] {
        i = i.successor()
        if i == query.endIndex {
          result.appendContentsOf(with)
          buffer.removeAll()
          i = query.startIndex
        } else {
          buffer.append(e)
        }
      } else {
        result.appendContentsOf(buffer)
        result.append(e)
        buffer.removeAll()
        i = query.startIndex
      }
    }
    return result
  }
}


extension SequenceType where Generator.Element : SequenceType {
  func join() -> JoinSequence<Self> {
    return self.joinWithSeparator([])
  }
}


extension SequenceType where Generator.Element == String {
  func join() -> String {
    return joinWithSeparator("")
  }
}


extension SequenceType where Generator.Element == Bool {

  func all() -> Bool {
    for e in self {
      if !e {
        return false
      }
    }
    return true
  }

  func any() -> Bool {
    for e in self {
      if e {
        return true
      }
    }
    return false
  }
}


func allZip<S1: SequenceType, S2: SequenceType>(seq1: S1, _ seq2: S2, predicate: (S1.Generator.Element, S2.Generator.Element) -> Bool) -> Bool {
  var g2 = seq2.generate()
  for e1 in seq1 {
    guard let e2 = g2.next() else { return false }
    if !predicate(e1, e2) {
      return false
    }
  }
  return g2.next() == nil
}
