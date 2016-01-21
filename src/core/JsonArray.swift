// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonArrayInitable {
  init(jsonArray: JsonArray) throws
}


struct JsonArray: JsonInitable {
  let array: NSArray

  init(array: NSArray) { self.array = array }

  init(json: JsonType) throws {
    if let array = json as? NSArray {
      self.init(array: array)
    } else { throw Json.Error.UnexpectedType(exp: NSArray.self, json: json) }
  }

  init(data: NSData) throws { self.init(array: try Json.fromData(data)) }

  init(stream: NSInputStream) throws { self.init(array: try Json.fromStream(stream)) }

  init(path: String) throws { self.init(array: try Json.fromPath(path)) }

  var count: Int { return array.count }

  @warn_unused_result
  func el<T: JsonInitable>(index: Int) throws -> T {
    if index >= count { throw Json.Error.MissingEl(index: index, exp: T.self, json: array) }
    return try T.init(json: array[index] as! JsonType)
  }

  @warn_unused_result
  func el<T: JsonArrayInitable>(index: Int) throws -> T {
    if index >= count { throw Json.Error.MissingEl(index: index, exp: T.self, json: array) }
    return try T.init(jsonArray: JsonArray(json: array[index] as! JsonType))
  }

  @warn_unused_result
  func convert<T: JsonInitable>() throws -> [T] {
    return try array.map { try T.init(json: $0 as! JsonType) }
  }

  @warn_unused_result
  func convert<T: JsonArrayInitable>() throws -> [T] {
    return try array.map { try T.init(jsonArray: try JsonArray(json: $0 as! JsonType)) }
  }
}
