// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonArrayInitable {
  init(jsonArray: JsonArray) throws
}


extension JsonArrayInitable {
  init(json: JsonType) throws {
    let jsonArray = try JsonArray(json: json)
    try self.init(jsonArray: jsonArray)
  }
}


extension JsonType {
  func asArray() throws -> JsonArray {
    guard let a = self as? NSArray else {
      throw Json.Error.unexpectedType(exp: JsonArray.self, json: self)
    }
    return JsonArray(raw: a)
  }

  func convArray<T: JsonArrayInitable>() throws -> T {
    return try T(jsonArray: try asArray())
  }
}


struct JsonArray: JsonInitable {
  let raw: NSArray

  init(raw: NSArray) { self.raw = raw }

  init(json: JsonType) throws {
    if let raw = json as? NSArray {
      self.init(raw: raw)
    } else { throw Json.Error.unexpectedType(exp: NSArray.self, json: json) }
  }

  init(anyJson: JsonType) { // for non-array input, create an array of one element.
    self.init(raw: (anyJson as? NSArray).or(NSArray(object: anyJson)))
  }

  init(data: Data) throws { self.init(raw: try Json.fromData(data)) }

  init(stream: InputStream) throws { self.init(raw: try Json.fromStream(stream)) }

  init(path: String) throws { self.init(raw: try Json.fromPath(path)) }

  var count: Int { return raw.count }

  subscript(index: Int) -> JsonType {
    return raw[index] as! JsonType
  }

  @warn_unused_result
  func el(_ index: Int) throws -> JsonType {
    if index >= count { throw Json.Error.missingEl(index: index, json: raw) }
    return raw[index] as! JsonType
  }

  /* TODO
  @warn_unused_result
  func convEls<T: JsonInitable>(start: Int = 0, end: Int? = nil) throws -> [T] {
    let range = start..<end.or(raw.count)
    return try raw[range].map { try T.init(json: $0 as! JsonType) }
  }

  @warn_unused_result
  func convArrays<T: JsonArrayInitable>(start: Int = 0, end: Int? = nil) throws -> [T] {
    let range = start..<end.or(raw.count)
    return try raw[range].map { try T.init(jsonArray: try JsonArray(json: $0 as! JsonType)) }
  }

  @warn_unused_result
  func convDicts<T: JsonDictInitable>(start: Int = 0, end: Int? = nil) throws -> [T] {
    let range = start..<end.or(raw.count)
    return try raw[range].map { try T.init(jsonDict: try JsonDict(json: $0 as! JsonType)) }
  }
 */
}
