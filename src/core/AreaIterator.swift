// © 2015 George King. Permission to use this file is granted in license.txt.


struct AreaIterator: SequenceType, GeneratorType {
  typealias Element = V2I
  typealias Generator = AreaIterator

  var size: V2I
  var coord = V2I()

  init(size: V2I) {
    self.size = size
  }

  mutating func next() -> Element? {
    if size.x <= 0 || coord.y >= size.y { return nil }
    let c = coord
    if coord.x < size.x - 1 {
      coord.x++
    } else {
    coord.x = 0
    coord.y += 1
    }
    return c
  }
}



