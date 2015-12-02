// © 2015 George King. Permission to use this file is granted in license-qk.txt.


class AreaBuffer<Element>: CollectionType {

  typealias Generator = Array<Element>.Generator
  typealias Index = Array<Element>.Index
  typealias Row = ArraySlice<Element>

  private(set) var size: V2I = V2I()
  private(set) var array: Array<Element> = []

  init() {}

  convenience init<S: SequenceType where S.Generator.Element == Element>(size: V2I, seq: S) {
    self.init()
    self.size = size
    self.array = Array(seq)
    if size.x * size.y != array.count { fatalError("AreaBuffer size \(size) does not match count: \(array.count)") }
  }

  convenience init(size: V2I, val: Element) {
    self.init()
    resize(size, val: val)
  }

  var count: Int { return array.count }

  func generate() -> Generator { return array.generate() }

  var startIndex: Index { return array.startIndex }

  var endIndex: Index { return array.endIndex }

  subscript (i: Int) -> Element {
    get { return array[i] }
    set { array[i] = newValue }
  }

  subscript (range: Range<Index>) -> ArraySlice<Element> {
    get { return array[range] }
    set { array[range] = newValue }
  }

  func withUnsafeBufferPointer<R>(@noescape body: (UnsafeBufferPointer<Element>) -> R) -> R {
    return array.withUnsafeBufferPointer(body)
  }

  func allCoords(start start: V2I, end: V2I, step: V2I = V2I(1, 1)) -> AreaIterator {
    return AreaIterator(start: start, end: end, step: step)
  }

  func allCoords(end end: V2I, step: V2I = V2I(1, 1)) -> AreaIterator {
    return allCoords(start: V2I(), end: end, step: step)
  }

  func allCoords(step step: V2I = V2I(1, 1)) -> AreaIterator {
    return allCoords(start: V2I(), end: size, step: step)
  }

  func allCoords(inset inset: Int) -> AreaIterator {
    return allCoords(start: V2I(inset, inset), end: V2I(size.x - inset, size.y - inset))
  }

  func resize(size: V2I, val: Element) {
    self.size = size
    array.removeAll(keepCapacity: true)
    for _ in 0..<(size.x * size.y) {
      array.append(val)
    }
  }
  
  func index(coord: V2I) -> Int {
    return size.x * coord.y + coord.x
  }

  func coord(index: Int) -> V2I {
    return V2I(index % size.x, index / size.x)
  }

  func isInBounds(coord: V2I) -> Bool {
    return coord.x >= 0 && coord.x < size.x && coord.y >= 0 && coord.y < size.y
  }

  func isOnEdge(coord: V2I) -> Bool {
    return coord.x == 0 || coord.x == size.x - 1 || coord.y == 0 || coord.y == size.y - 1
  }

  func isOnHighEdge(coord: V2I) -> Bool {
    return coord.x == size.x - 1 || coord.y == size.y - 1
  }

  func isOnEdge(index: Int) -> Bool {
    return isOnEdge(coord(index))
  }

  func isOnHighEdge(index: Int) -> Bool {
    return isOnHighEdge(coord(index))
  }
  
  func row(y: Int) -> Row {
    let off = size.x * y
    return self[off..<(off + size.x)]
  }

  func el(x: Int, _ y: Int) -> Element {
    return self[size.x * y + x]
  }

  func el(coord: V2I) -> Element { return el(coord.x, coord.y) }
  
  func setEl(i: Int, _ j: Int, _ val: Element) {
    self[size.x * j + i] = val
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

