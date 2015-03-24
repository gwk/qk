// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


func find<C: CollectionType where C.Generator.Element: Equatable>(domain: C, query: C,
  start: C.Index? = nil, end: C.Index? = nil) -> Range<C.Index>? {
    var i = start.or(domain.startIndex)
    let e = end.or(domain.endIndex)
    while i != e {
      var j = i
      var found = true
      for c in query {
        if j == e {
          return nil // ran out of domain.
        }
        if c != domain[j] {
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


func part<C: Sliceable>(collection: C, range: Range<C.Index>) -> (C.SubSlice, C.SubSlice) {
  let ra = collection.startIndex..<range.startIndex
  let rb = range.endIndex..<collection.endIndex
  return (collection[ra], collection[rb])
}


func part<C: Sliceable where C.Generator.Element: Equatable>(collection: C, separator: C,
  start: C.Index? = nil, end: C.Index? = nil) -> (C.SubSlice, C.SubSlice)? {
    if let range = find(collection, separator, start: start, end: end) {
      return part(collection, range)
    }
    return nil
}