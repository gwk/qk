// © 2015 George King. Permission to use this file is granted in license-qk.txt.


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
    super.resize(size.x * size.y, val: val)
    _size = size
  }
  
  func row(y: Int) -> Row {
    let off = size.x * y
    return self[off..<(off + size.x)]
  }

  func inBounds(coord: V2I) -> Bool {
    return coord.x >= 0 && coord.x < _size.x && coord.y >= 0 && coord.y < _size.y
  }
  
  func el(i: Int, _ j: Int) -> T {
    return self[_size.x * j + i]
  }

  func el(coord: V2I) -> T { return el(coord.x, coord.y) }
  
  func setEl(i: Int, _ j: Int, _ val: T) {
    self[_size.x * j + i] = val
  }
  
  func setEl(coord: V2I, _ val: T) { setEl(coord.x, coord.y, val) }
}


extension AreaBuffer where T: ArithmeticType {
  func addEl(coord: V2I, _ delta: T) -> T {
    var val = el(coord)
    val = val + delta
    setEl(coord, val)
    return val
  }
}

