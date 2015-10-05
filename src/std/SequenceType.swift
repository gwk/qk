// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension SequenceType {
  
  func mapThrows<T>(@noescape transform: (Generator.Element) throws -> T) throws -> [T] {
    var a = [T]()
    for e in self {
      let v = try transform(e)
      a.append(v)
    }
    return a
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


extension SequenceType where Generator.Element == String {
  func join() -> String {
    return joinWithSeparator("")
  }
}

