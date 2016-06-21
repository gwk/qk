// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSArray: CollectionType {
  public typealias SubSequenceType = NSArraySlice

  public var startIndex: Int { return 0 }
  public var endIndex: Int { return count }

  public subscript (range: Range<Int>) -> NSArraySlice {
    return NSArraySlice(array: self, range: range)
  }

  public func array<T>() -> [T] {
    var a: [T] = []
    for el in self {
      a.append(el as! T)
    }
    return a
  }
}
