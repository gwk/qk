// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonDictInitable {
  init(jsonDict: JsonDict) throws
}


struct JsonDict: JsonInitable {
  let raw: NSDictionary

  init(raw: NSDictionary) { self.raw = raw }

  init(json: JsonType) throws {
    if let raw = json as? NSDictionary {
      self.init(raw: raw)
    } else { throw Json.Error.UnexpectedType(exp: NSDictionary.self, json: json) }
  }

  init(data: NSData) throws { self.init(raw: try Json.fromData(data)) }

  init(stream: NSInputStream) throws { self.init(raw: try Json.fromStream(stream)) }

  init(path: String) throws { self.init(raw: try Json.fromPath(path)) }

  @warn_unused_result
  func array(key: String) throws -> JsonArray {
    guard let val = raw[key] else { throw Json.Error.Key(key: key, exp: JsonArray.self, json: raw) }
    guard let array = val as? NSArray else { throw Json.Error.UnexpectedType(exp: JsonArray.self, json: val as! JsonType) }
    return JsonArray(raw: array)
  }

  @warn_unused_result
  func dict(key: String) throws -> JsonDict {
    guard let val = raw[key] else { throw Json.Error.Key(key: key, exp: JsonDict.self, json: raw) }
    guard let raw = val as? NSDictionary else { throw Json.Error.UnexpectedType(exp: JsonDict.self, json: val as! JsonType) }
    return JsonDict(raw: raw)
  }

  @warn_unused_result
  func get<T: JsonInitable>(key: String) throws -> T {
    guard let val = raw[key] else { throw Json.Error.Key(key: key, exp: T.self, json: raw) }
    return try T.init(json: val as! JsonType)
  }
  
  @warn_unused_result
  func get<T: JsonArrayInitable>(key: String) throws -> T {
    return try T.init(jsonArray: try array(key))
  }
  
  @warn_unused_result
  func get<T: JsonDictInitable>(key: String) throws -> T {
    return try T.init(jsonDict: try dict(key))
  }
  
}
