// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension Sequence {

  @warn_unused_result
  func group<K: Hashable>(_ fn: @noescape (Iterator.Element) -> K?) -> [K:[Iterator.Element]] {
    var d: [K:[Iterator.Element]] = [:]
    for e in self {
      if let k = fn(e) {
        d.appendToValue(k, e)
      }
    }
    return d
  }

  func groupSorted(predicate: (l: Generator.Element, r: Generator.Element) -> Bool) -> [[Generator.Element]] {
    var generator = generate()
    guard let first = generator.next() else { return [] }
    var groups: [[Generator.Element]] = []
    var group: [Generator.Element] = [first]
    var prev = first
    while let el = generator.next() {
      if predicate(l: prev, r: el) { // same group.
        group.append(el)
      } else {
        groups.append(group)
        group = [el]
      }
      prev = el
    }
    if !group.isEmpty {
      groups.append(group)
    }
    return groups
  }

  @warn_unused_result
  func filterMap<E>(transform: @noescape (Iterator.Element) throws -> E?) rethrows -> [E] {
    var a: [E] = []
    for e in self {
      if let t = try transform(e) {
        a.append(t)
      }
    }
    return a
  }

  @warn_unused_result
  func mapToDict<K: Hashable, V>(_ transform: @noescape (Iterator.Element) -> (K, V)) -> [K:V] {
    var d: [K:V] = [:]
    for e in self {
      let (k, v) = transform(e)
      d[k] = v
    }
    return d
  }

  @warn_unused_result
  func mapUniquesToDict<K: Hashable, V>(_ transform: @noescape (Iterator.Element) -> (K, V)) throws -> [K:V] {
    var d: [K:V] = [:]
    for e in self {
      let (k, v) = transform(e)
      if d.contains(k) { throw DuplicateKeyError(key: k, existing: d[k], incoming: v) }
      d[k] = v
    }
    return d
  }

  @warn_unused_result
  func all(_ predicate: @noescape (Iterator.Element) -> Bool) -> Bool {
    for e in self {
      if !predicate(e) {
        return false
      }
    }
    return true
  }

  @warn_unused_result
  func any(_ predicate: @noescape (Iterator.Element) -> Bool) -> Bool {
    for e in self {
      if predicate(e) {
        return true
      }
    }
    return false
  }

  var first: Iterator.Element? {
    for first in self {
      return first
    }
    return nil
  }
}


extension Sequence where Iterator.Element: Equatable {

  @warn_unused_result
  func replace(_ query: Iterator.Element, with: Iterator.Element) -> [Iterator.Element] {
    var result: [Iterator.Element] = []
    for e in self {
      if e == query {
        result.append(with)
      } else {
        result.append(e)
      }
    }
    return result
  }

  @warn_unused_result
  func replace<Q: Collection, W: Collection where Q.Iterator.Element == Iterator.Element, W.Iterator.Element == Iterator.Element>(_ query: Q, with: W) -> [Iterator.Element] {
    if query.isEmpty {
      return Array(self)
    }
    var buffer: [Iterator.Element] = []
    var result: [Iterator.Element] = []
    var i = query.startIndex
    for e in self {
      if e == query[i] {
        i = query.index(after: i)
        if i == query.endIndex {
          result.append(contentsOf: with)
          buffer.removeAll()
          i = query.startIndex
        } else {
          buffer.append(e)
        }
      } else {
        result.append(contentsOf: buffer)
        result.append(e)
        buffer.removeAll()
        i = query.startIndex
      }
    }
    return result
  }

  @warn_unused_result
  func countOccurrencesOf(_ el: Iterator.Element) -> Int {
    return reduce(0) { $1 == el ? $0 + 1 : $0 }
  }
}


extension Sequence where Iterator.Element : Sequence {

  @warn_unused_result
  func join() -> JoinedSequence<Self> {
    return self.joined(separator: [])
  }
}


extension Sequence where Iterator.Element == String {

  @warn_unused_result
  func join() -> String {
    return joined( separator: "")
  }
}


extension Sequence where Iterator.Element == Bool {

  @warn_unused_result
  func all() -> Bool {
    for e in self {
      if !e {
        return false
      }
    }
    return true
  }

  @warn_unused_result
  func any() -> Bool {
    for e in self {
      if e {
        return true
      }
    }
    return false
  }
}


@warn_unused_result
func allZip<S1: Sequence, S2: Sequence>(_ seq1: S1, _ seq2: S2, predicate: (S1.Iterator.Element, S2.Iterator.Element) -> Bool) -> Bool {
  var g2 = seq2.makeIterator()
  for e1 in seq1 {
    guard let e2 = g2.next() else { return false }
    if !predicate(e1, e2) {
      return false
    }
  }
  return g2.next() == nil
}
