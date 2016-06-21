// © 2015 George King. Permission to use this file is granted in license-qk.txt.


struct RotatedIndexIterator: SequenceType, GeneratorType {
  typealias Element = Int
  let count: Int
  let start: Int
  var step: Int

  init(count: Int, start: Int) {
    self.count = count
    self.start = start
    self.step = 0
  }

  mutating func next() -> Element? {
    if step == count {
      return nil
    }
    let i = step
    step += 1
    return (i + start) % count
  }
}




