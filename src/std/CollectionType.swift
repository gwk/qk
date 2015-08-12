// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


extension CollectionType {
  
  typealias Element = Self.Generator.Element
  
  func mapThrows<T>(@noescape transform: (Element) throws -> T) throws -> [T] {
    var a = [T]()
    for e in self {
      let v = try transform(e)
      a.append(v)
    }
    return a
  }
}


extension CollectionType where Generator.Element : Equatable {
  
  func rangeOf(query: Self, start: Index? = nil, end: Index? = nil) -> Range<Index>? {
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
  
  func has(query: Self, atIndex: Index) -> Bool {
    var i = atIndex
    for e in query {
      if i == endIndex || e != self[i] {
        return false
      }
      i = i.successor()
    }
    return true
  }
}


extension CollectionType where Generator.Element : Equatable {
  
  func part(range: Range<Index>) -> (SubSequence, SubSequence) {
    let ra = startIndex..<range.startIndex
    let rb = range.endIndex..<endIndex
    return (self[ra], self[rb])
  }
  
  func part(sep: Self, start: Index? = nil, end: Index? = nil) -> (SubSequence, SubSequence)? {
      if let range = rangeOf(sep, start: start, end: end) {
        return part(range)
      }
      return nil
  }
}

