// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension Collection where Iterator.Element : Equatable {

  var range: Range<Index> { return startIndex..<endIndex }

  @warn_unused_result
  func has<C: Collection where C.Iterator.Element == Iterator.Element>(_ query: C, atIndex: Index) -> Bool {
    var i = atIndex
    for e in query {
      if i == endIndex || e != self[i] {
        return false
      }
      i = index(after: i)
    }
    return true
  }

  @warn_unused_result
  func part(_ range: Range<Index>) -> (SubSequence, SubSequence) {
    let ra = startIndex..<range.lowerBound
    let rb = range.upperBound..<endIndex
    return (self[ra], self[rb])
  }

  @warn_unused_result
  func part(_ separator: Self, start: Index? = nil, end: Index? = nil) -> (SubSequence, SubSequence)? {
    if let range = rangeOf(separator, start: start, end: end) {
      return part(range)
    }
    return nil
  }

  @warn_unused_result
  func rangeOf<C: Collection where C.Iterator.Element == Iterator.Element>(_ query: C, start: Index? = nil, end: Index? = nil) -> Range<Index>? {
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
        j = index(after: j)
      }
      if found { // all characters matched.
        return i..<j
      }
      i = index(after: i)
    }
    return nil
  }
  
  @warn_unused_result
  func split<C: Collection where C.Iterator.Element == Iterator.Element>(sub: C, maxSplit: Int = Int.max, allowEmptySlices: Bool = false) -> [Self.SubSequence] {
    var result: [Self.SubSequence] = []
    var prev = startIndex
    var range = rangeOf(sub)
    while let r = range {
      if allowEmptySlices || prev != r.lowerBound {
        result.append(self[prev..<r.lowerBound])
      }
      prev = r.upperBound
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


extension Collection where Iterator.Element: Comparable {

  var isSorted: Bool {
    var prev: Iterator.Element? = nil
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


func zipExact<C0: Collection, C1: Collection where C0.IndexDistance == C1.IndexDistance>(_ c0: C0, _ c1: C1) ->
  Zip2Sequence<C0, C1> {
  assert(c0.count == c1.count)
  return zip(c0, c1)
}
