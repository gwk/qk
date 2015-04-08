// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


class AreaBuffer<T> {
  typealias Row = ArraySlice<T>
  private var _size: V2I
  private var _array: ContiguousArray<T>
  
  init() {
    _size = V2I()
    _array = ContiguousArray<T>()
  }
  
  var size: V2I { return _size }
  var count: Int { return _array.count }
  
  func resize(size: V2I, val: T) {
    _array.removeAll(keepCapacity: true)
    _size = size
    let c = _size.x * _size.y
    _array.extend(lazy(0..<c).map({ (i) in return val }))
  }
  
  func row(row: Int) -> Row {
    let off = size.x * row
    return _array[off..<(off + size.x)]
  }
  
  func el(i: Int, _ j: Int) -> T {
    return _array[_size.x * j + i]
  }

  func el(coord: V2I) -> T { return el(coord.x, coord.y) }
  
  func setEl(i: Int, _ j: Int, _ val: T) {
    _array[_size.x * j + i] = val
  }
  
  func setEl(coord: V2I, _ val: T) { setEl(coord.x, coord.y, val) }

  subscript (i: Int) -> T {
    get { return _array[i] }
    set { _array[i] = newValue }
  }
  
  func withUnsafeBufferPointer<R>(@noescape body: (UnsafeBufferPointer<T>) -> R) -> R {
    return _array.withUnsafeBufferPointer(body)
  }

}

