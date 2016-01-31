// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension CollectionType where Generator.Element : Equatable {

  var range: Range<Index> { return startIndex..<endIndex }

  @warn_unused_result
  func has<C: CollectionType where C.Generator.Element == Generator.Element>(query: C, atIndex: Index) -> Bool {
    var i = atIndex
    for e in query {
      if i == endIndex || e != self[i] {
        return false
      }
      i = i.successor()
    }
    return true
  }

  @warn_unused_result
  func part(range: Range<Index>) -> (SubSequence, SubSequence) {
    let ra = startIndex..<range.startIndex
    let rb = range.endIndex..<endIndex
    return (self[ra], self[rb])
  }

  @warn_unused_result
  func part(separator: Self, start: Index? = nil, end: Index? = nil) -> (SubSequence, SubSequence)? {
    if let range = rangeOf(separator, start: start, end: end) {
      return part(range)
    }
    return nil
  }

  @warn_unused_result
  func rangeOf<C: CollectionType where C.Generator.Element == Generator.Element>(query: C, start: Index? = nil, end: Index? = nil) -> Range<Index>? {
    var i = start.or(startIndex)
    let e = end.or(endIndex)
    while i != e {
      var j = i
      var found = true
      for el in query {
        if j == e {
          return nil // ran out of domain.
        }
        if el != self[j] {
          found = false
          break
        }
        j = j.successor()
      }
      if found { // all characters matched.
        return i..<j
      }
      i = i.successor()
    }
    return nil
  }
  
  @warn_unused_result
  func split<C: CollectionType where C.Generator.Element == Generator.Element>(sub sub: C, maxSplit: Int = Int.max, allowEmptySlices: Bool = false) -> [Self.SubSequence] {
    var result: [Self.SubSequence] = []
    var prev = startIndex
    var range = rangeOf(sub)
    while let r = range {
      if allowEmptySlices || prev != r.startIndex {
        result.append(self[prev..<r.startIndex])
      }
      prev = r.endIndex
      range = rangeOf(sub, start: prev)
      if result.count == maxSplit {
        break
      }
    }
    if allowEmptySlices || prev != endIndex {
      result.append(self[prev..<endIndex])
    }
    return result
  }
}


extension CollectionType where Generator.Element: Comparable {

  var isSorted: Bool {
    var prev: Generator.Element? = nil
    for el in self {
      if let prev = prev {
        if !(prev < el) {
          return false
        }
      }
      prev = el
    }
    return true
  }
}

