// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


class Arr<T>: CollectionType {
  private var _array: ContiguousArray<T>
  
  init() {
    _array = ContiguousArray<T>()
  }

  var count: Int { return _array.count }

  typealias Generator = ContiguousArray<T>.Generator
  
  func generate() -> Generator { return _array.generate() }
  
  typealias Index = ContiguousArray<T>.Index

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
    _array.extend(lazy(0..<count).map { (i) in return val })
  }
  
  func withUnsafeBufferPointer<R>(@noescape body: (UnsafeBufferPointer<T>) -> R) -> R {
    return _array.withUnsafeBufferPointer(body)
  }
}

