// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension SequenceType {
  
  func mapThrows<T>(@noescape transform: (Self.Generator.Element) throws -> T) throws -> [T] {
    var a = [T]()
    for e in self {
      let v = try transform(e)
      a.append(v)
    }
    return a
  }
}



