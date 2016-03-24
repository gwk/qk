// © 2015 George King. Permission to use this file is granted in license.txt.


struct AreaIterator: Sequence, IteratorProtocol {
  typealias Element = V2I
  typealias Generator = AreaIterator

  var start: V2I
  var end: V2I
  var step: V2I
  var coord: V2I

  init(start: V2I, end: V2I, step: V2I) {
    self.start = start
    self.end = end
    self.step = step
    self.coord = start
  }

  mutating func next() -> Element? {
    if end.x <= 0 || coord.y >= end.y { return nil }
    let c = coord
    coord.x += step.x
    if coord.x >= end.x {
      coord.x = start.x
      coord.y += step.y
    }
    return c
  }
}



