// © 2015 George King. Permission to use this file is granted in license-qk.txt.


class AreaBuffer<Element>: ArrayRef<Element> {
  typealias Row = ArraySlice<Element>

  private var _size: V2I
  
  override init() {
    _size = V2I()
    super.init()
  }

  convenience init(size: V2I, val: Element) {
    self.init()
    resize(size, val: val)
  }

  convenience init<S: SequenceType where S.Generator.Element == Element>(size: V2I, seq: S) {
    self.init()
    self._size = size
    self.array = Array(seq)
  }

  var size: V2I { return _size }

  func allCoords(start start: V2I, end: V2I, step: V2I = V2I(1, 1)) -> AreaIterator {
    return AreaIterator(start: start, end: end, step: step)
  }

  func allCoords(end end: V2I, step: V2I = V2I(1, 1)) -> AreaIterator {
    return allCoords(start: V2I(), end: end, step: step)
  }

  func allCoords(step step: V2I = V2I(1, 1)) -> AreaIterator {
    return allCoords(start: V2I(), end: _size, step: step)
  }

  override func resize(count: Int, val: Element) { fatalError("use resize(size: V2I, val: Element)") }

  func resize(size: V2I, val: Element) {
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
  
  func el(i: Int, _ j: Int) -> Element {
    return self[_size.x * j + i]
  }

  func el(coord: V2I) -> Element { return el(coord.x, coord.y) }
  
  func setEl(i: Int, _ j: Int, _ val: Element) {
    self[_size.x * j + i] = val
  }
  
  func setEl(coord: V2I, _ val: Element) { setEl(coord.x, coord.y, val) }

  func map<R>(transform: (Element)->R) -> AreaBuffer<R> {
    return AreaBuffer<R>(size: size, seq: array.map(transform))
  }
}


extension AreaBuffer where Element: ArithmeticType {
  func addEl(coord: V2I, _ delta: Element) -> Element {
    var val = el(coord)
    val = val + delta
    setEl(coord, val)
    return val
  }
}

