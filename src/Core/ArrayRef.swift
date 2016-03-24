// © 2015 George King. Permission to use this file is granted in license-qk.txt.


class ArrayRef<Element>: Collection {
  // pass-by-reference Array type.
  
  typealias Generator = Array<Element>.Generator
  typealias Index = Array<Element>.Index
  
  var array: Array<Element> = []
  
  init() {}

  convenience init(count: Int, val: Element) {
    self.init()
    resize(count, val: val)
  }

  convenience init<S: Sequence where S.Generator.Element == Element>(seq: S) {
    self.init()
    array = Array(seq)
  }

  var count: Int { return array.count }
  
  func generate() -> Generator { return array.generate() }

  var startIndex: Index { return array.startIndex }

  var endIndex: Index { return array.endIndex }

  subscript (index: Index) -> Element {
    get { return array[index] }
    set { array[index] = newValue }
  }
  
  subscript (range: Range<Index>) -> ArraySlice<Element> {
    get { return array[range] }
    set { array[range] = newValue }
  }
  
  func resize(count: Int, val: Element) {
    array.removeAll(keepCapacity: true)
    for _ in 0..<count {
      array.append(val)
    }
  }
  
  func withUnsafeBufferPointer<R>(@noescape body: (UnsafeBufferPointer<Element>) -> R) -> R {
    return array.withUnsafeBufferPointer(body)
  }
}

