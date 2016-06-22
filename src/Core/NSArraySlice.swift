// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation

/* TODO
public struct NSArraySlice: Collection {

  public struct Iterator: IteratorProtocol {
    private var index
    private let endIndex

    public mutating func next() -> AnyObject? {
      if range.isEmpty {
        return nil
      } else {
        let index = range.startIndex
        range.startIndex += 1
        return array[index]
      }
    }

  }

  public let array: NSArray
  public var range: CountableRange<Int>

  public init(array: NSArray, range: CountableRange<Int>) {
    self.array = array
    self.range = range
  }

  public var startIndex: Int { return range.startIndex }
  public var endIndex: Int { return range.endIndex }

  public func makeIterator() -> Iterator {
    return Iterator(index: range.startIndex, endINdex: range.endIndex)
  }

  public subscript (index: Int) -> AnyObject {
    assert(range.contains(index))
    return array[index]
  }

  public subscript (subRange: Range<Int>) -> NSArraySlice {
    return NSArraySlice(array: array, range: subRange)
  }
}
*/
