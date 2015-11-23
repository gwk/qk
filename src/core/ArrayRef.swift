// © 2015 George King. Permission to use this file is granted in license-qk.txt.


class ArrayRef<T>: CollectionType {
  // pass-by-reference Array type.
  
  typealias Generator = ContiguousArray<T>.Generator
  typealias Index = ContiguousArray<T>.Index
  
  private var _array: ContiguousArray<T>
  
  init() {
    _array = ContiguousArray<T>()
  }

  var count: Int { return _array.count }
  
  func generate() -> Generator { return _array.generate() }
  
  var startIndex: Index { return _array.startIndex }

  var endIndex: Index { return _array.endIndex }

  subscript (i: Int) -> T {
    get { return _array[i] }
    set { _array[i] = newValue }
  }
  
  subscript (range: Range<Index>) -> ArraySlice<T> {
    get { return _array[range] }
    set { _array[range] = newValue }
  }
  
  func resize(count: Int, val: T) {
    _array.removeAll(keepCapacity: true)
    for _ in 0..<count {
      _array.append(val)
    }
  }
  
  func withUnsafeBufferPointer<R>(@noescape body: (UnsafeBufferPointer<T>) -> R) -> R {
    return _array.withUnsafeBufferPointer(body)
  }
}

