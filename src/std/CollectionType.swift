// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


extension CollectionType where Generator.Element : Equatable {
  
  func rangeOf(query: Self, start: Index? = nil, end: Index? = nil) -> Range<Index>? {
    var i = start.or(startIndex)
    let e = end.or(endIndex)
    while i != e {
      var j = i
      var found = true
      for c in query {
        if j == e {
          return nil // ran out of domain.
        }
        if c != self[j] {
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
  
}


extension CollectionType where Self : Sliceable, Generator.Element : Equatable {
  
  func part(range: Range<Index>) -> (SubSlice, SubSlice) {
    let ra = startIndex..<range.startIndex
    let rb = range.endIndex..<endIndex
    return (self[ra], self[rb])
  }
  
  func part(sep: Self, start: Index? = nil, end: Index? = nil) -> (SubSlice, SubSlice)? {
      if let range = rangeOf(sep, start: start, end: end) {
        return part(range)
      }
      return nil
  }
}

