// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonArrayInitable {
  init(jsonArray: JsonArray) throws
}


struct JsonArray: JsonInitable {
  let raw: NSArray

  init(raw: NSArray) { self.raw = raw }

  init(json: JsonType) throws {
    if let raw = json as? NSArray {
      self.init(raw: raw)
    } else { throw Json.Error.UnexpectedType(exp: NSArray.self, json: json) }
  }

  init(data: NSData) throws { self.init(raw: try Json.fromData(data)) }

  init(stream: NSInputStream) throws { self.init(raw: try Json.fromStream(stream)) }

  init(path: String) throws { self.init(raw: try Json.fromPath(path)) }

  var count: Int { return raw.count }

  
  @warn_unused_result
  func array(index: Int) throws -> JsonArray {
    if index >= count { throw Json.Error.MissingEl(index: index, exp: JsonArray.self, json: raw) }
    guard let a = raw[index] as? NSArray else {
      throw Json.Error.UnexpectedType(exp: JsonArray.self, json: raw[index] as! JsonType)
    }
    return JsonArray(raw: a)
  }

  @warn_unused_result
  func dict(index: Int) throws -> JsonDict {
    if index >= count { throw Json.Error.MissingEl(index: index, exp: JsonDict.self, json: raw) }
    guard let d = raw[index] as? NSDictionary else {
      throw Json.Error.UnexpectedType(exp: JsonDict.self, json: raw[index] as! JsonType)
    }
    return JsonDict(raw: d)
  }

  @warn_unused_result
  func el<T: JsonInitable>(index: Int) throws -> T {
    if index >= count { throw Json.Error.MissingEl(index: index, exp: T.self, json: raw) }
    return try T.init(json: raw[index] as! JsonType)
  }

  @warn_unused_result
  func el<T: JsonArrayInitable>(index: Int) throws -> T {
    return try T.init(jsonArray: try array(index))
  }

  @warn_unused_result
  func el<T: JsonDictInitable>(index: Int) throws -> T {
    return try T.init(jsonDict: try dict(index))
  }

  @warn_unused_result
  func convert<T: JsonInitable>() throws -> [T] {
    return try raw.map { try T.init(json: $0 as! JsonType) }
  }

  @warn_unused_result
  func convert<T: JsonArrayInitable>() throws -> [T] {
    return try raw.map { try T.init(jsonArray: try JsonArray(json: $0 as! JsonType)) }
  }

  @warn_unused_result
  func convert<T: JsonDictInitable>() throws -> [T] {
    return try raw.map { try T.init(jsonDict: try JsonDict(json: $0 as! JsonType)) }
  }
}
