// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonArrayConvertible {
  init(json: JsonArray) throws
}


struct JsonArray {
  let array: NSArray

  init(array: NSArray) { self.array = array }

  init(data: NSData) throws { self.init(array: try Json.fromData(data)) }

  init(stream: NSInputStream) throws { self.init(array: try Json.fromStream(stream)) }

  init(path: String) throws { self.init(array: try Json.fromPath(path)) }

  @warn_unused_result
  func el<T: JsonConvertible>(index: Int) throws -> T {
    return try T.init(json: array[index] as! JsonType)
  }
}

/*

extension NSArray {
func json<T: JsonConvertible>(index: Int) throws -> T {
return try T.init(json: self[index] as! JsonType)
}

func mapJson<T: JsonConvertible>() throws -> [T] {
return try self.map() { try T.init(json: $0 as! JsonType) }
}

func forEachJson<T: JsonConvertible>(body: (T)->()) throws {
for el in self {
try body(T.init(json: el as! JsonType))
}
}
}
*/