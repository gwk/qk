// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


struct Set<T: Hashable>: SequenceType {
  typealias Element = T
  //typealias Index = DictionaryIndex<T, ()>

  private var d: [T:()]

  func generate() -> GeneratorOf<T> {
    var g = d.generate()
    return GeneratorOf<T> {
      if let (k: T, v: ()) = g.next() {
        return k
      } else {
        return nil
      }
    }
  }

  //var startIndex: Index { return d.startIndex }
  //var endIndex: Index { return d.endIndex }
  //func indexForEl(el: T) -> Index? { return d.indexForKey(el) }

  func contains(el: T) -> Bool {
    return d[el] != nil
  }

  mutating func add(el: T) -> Bool {
    // returns true if the element was already in the set.
    return d.updateValue((), forKey: el) != nil
  }

  mutating func remove(el: T) -> Bool {
    // returns true if the element was in the set.
    return d.removeValueForKey(el) != nil
  }

  mutating func removeAll(keepCapacity: Bool = true) {
    d.removeAll(keepCapacity: keepCapacity)
  }

  init() {
    d = [:]
  }

  init<S: SequenceType where S.Generator.Element == T>(_ sequence: S) {
    d = [:]
    // simple "for e in sequence" yields this error:
    // cannot convert the expression's type 'S' to type 'S'.
    // workaround is to use SequenceOf "type-erased generator".
    for e in SequenceOf<T>(sequence) {
      add(e)
    }
  }
}
