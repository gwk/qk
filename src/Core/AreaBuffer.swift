// © 2015 George King. Permission to use this file is granted in license-qk.txt.


class AreaBuffer<Element>: Collection {

  typealias Iterator = Array<Element>.Iterator
  typealias Index = Array<Element>.Index
  typealias Row = ArraySlice<Element>

  private(set) var size: V2I = V2I()
  private(set) var array: Array<Element> = []

  init() {}

  convenience init<S: Sequence where S.Iterator.Element == Element>(size: V2I, seq: S) {
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

  @warn_unused_result
  func makeIterator() -> Iterator { return array.makeIterator() }

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

  func index(after i: Index) -> Index {
    return array.index(after: i)
  }
  
  func withUnsafeBufferPointer<R>(_ body: @noescape (UnsafeBufferPointer<Element>) -> R) -> R {
    return array.withUnsafeBufferPointer(body)
  }

  @warn_unused_result
  func allCoords(start: V2I, end: V2I, step: V2I = V2I(1, 1)) -> AreaIterator {
    return AreaIterator(start: start, end: end, step: step)
  }

  @warn_unused_result
  func allCoords(end: V2I, step: V2I = V2I(1, 1)) -> AreaIterator {
    return allCoords(start: V2I(), end: end, step: step)
  }

  @warn_unused_result
  func allCoords(step: V2I = V2I(1, 1)) -> AreaIterator {
    return allCoords(start: V2I(), end: size, step: step)
  }

  @warn_unused_result
  func allCoords(inset: Int) -> AreaIterator {
    return allCoords(start: V2I(inset, inset), end: V2I(size.x - inset, size.y - inset))
  }

  func resize(_ size: V2I, val: Element) {
    self.size = size
    array.removeAll(keepingCapacity: true)
    for _ in 0..<(size.x * size.y) {
      array.append(val)
    }
  }
  
  @warn_unused_result
  func index(_ coord: V2I) -> Int {
    return size.x * coord.y + coord.x
  }

  @warn_unused_result
  func coord(_ index: Int) -> V2I {
    return V2I(index % size.x, index / size.x)
  }

  @warn_unused_result
  func isInBounds(_ coord: V2I) -> Bool {
    return coord.x >= 0 && coord.x < size.x && coord.y >= 0 && coord.y < size.y
  }

  @warn_unused_result
  func isOnEdge(_ coord: V2I) -> Bool {
    return coord.x == 0 || coord.x == size.x - 1 || coord.y == 0 || coord.y == size.y - 1
  }

  @warn_unused_result
  func isOnHighEdge(_ coord: V2I) -> Bool {
    return coord.x == size.x - 1 || coord.y == size.y - 1
  }

  @warn_unused_result
  func isOnEdge(_ index: Int) -> Bool {
    return isOnEdge(coord(index))
  }

  @warn_unused_result
  func isOnHighEdge(_ index: Int) -> Bool {
    return isOnHighEdge(coord(index))
  }
  
  @warn_unused_result
  func row(_ y: Int) -> Row {
    let off = size.x * y
    return self[off..<(off + size.x)]
  }

  @warn_unused_result
  func el(_ x: Int, _ y: Int) -> Element {
    return self[size.x * y + x]
  }

  @warn_unused_result
  func el(_ coord: V2I) -> Element { return el(coord.x, coord.y) }
  
  func setEl(_ i: Int, _ j: Int, _ val: Element) {
    self[size.x * j + i] = val
  }
  
  func setEl(_ coord: V2I, _ val: Element) { setEl(coord.x, coord.y, val) }

  @warn_unused_result
  func map<R>(_ transform: (Element)->R) -> AreaBuffer<R> {
    return AreaBuffer<R>(size: size, seq: array.map(transform))
  }
}


extension AreaBuffer where Element: ArithmeticProtocol {

  func addEl(_ coord: V2I, _ delta: Element) -> Element {
    var val = el(coord)
    val = val + delta
    setEl(coord, val)
    return val
  }
}

