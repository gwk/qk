// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


public struct NSArraySlice: CollectionType, GeneratorType {
  public typealias Generator = NSArraySlice

  public let array: NSArray
  public var range: Range<Int>

  public init(array: NSArray, range: Range<Int>) {
    self.array = array
    self.range = range
  }

  public var startIndex: Int { return range.startIndex }
  public var endIndex: Int { return range.endIndex }

  public func generate() -> Generator { return self }

  public mutating func next() -> AnyObject? {
    if range.isEmpty {
      return nil
    } else {
      let index = range.startIndex
      range.startIndex += 1
      return array[index]
    }
  }

  public subscript (index: Int) -> AnyObject {
    assert(range.contains(index))
    return array[index]
  }

  public subscript (subRange: Range<Int>) -> NSArraySlice {
    return NSArraySlice(array: array, range: subRange)
  }
}
