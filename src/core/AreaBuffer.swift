// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


class AreaBuffer<T>: ArrayRef<T> {
  typealias Row = ArraySlice<T>
  private var _size: V2I
  
  override init() {
    _size = V2I()
    super.init()
  }
  
  var size: V2I { return _size }
  
  override func resize(count: Int, val: T) { fatalError("use resize(size: V2I, val: T)") }

  func resize(size: V2I, val: T) {
    super.resize(Int(size.x * size.y), val: val)
    _size = size
  }
  
  func row(row: Int) -> Row {
    let off = Int(size.x) * row
    return self[off..<(off + Int(size.x))]
  }
  
  func el(i: Int, _ j: Int) -> T {
    return self[Int(_size.x) * j + i]
  }

  func el(coord: V2I) -> T { return el(Int(coord.x), Int(coord.y)) }
  
  func setEl(i: Int, _ j: Int, _ val: T) {
    self[Int(_size.x) * j + i] = val
  }
  
  func setEl(coord: V2I, _ val: T) { setEl(Int(coord.x), Int(coord.y), val) }
}

