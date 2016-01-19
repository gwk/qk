// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonDictInitable {
  init(json: JsonDict) throws
}


struct JsonDict {
  let dict: NSDictionary

  init(dict: NSDictionary) { self.dict = dict }

  init(data: NSData) throws { self.init(dict: try Json.fromData(data)) }

  init(stream: NSInputStream) throws { self.init(dict: try Json.fromStream(stream)) }

  init(path: String) throws { self.init(dict: try Json.fromPath(path)) }

  @warn_unused_result
  func get<T: JsonInitable>(key: String) throws -> T {
  guard let val = dict[key] else { throw Json.Error.Key(key: key, exp: T.self, json: dict) }
  return try T.init(json: val as! JsonType)
  }

  @warn_unused_result
  func array<T: JsonInitable>(key: String) throws -> [T] {
    guard let val = dict[key] else { throw Json.Error.Key(key: key, exp: Array<T>.self, json: dict) }
    guard let array = val as? NSArray else { throw Json.Error.UnexpectedType(exp: Array<T>.self, json: val as! JsonType) }
    return try array.map() { try T.init(json: $0 as! JsonType) }
  }

  @warn_unused_result
  func array<T: JsonDictInitable>(key: String) throws -> [T] {
    guard let val = dict[key] else { throw Json.Error.Key(key: key, exp: Array<T>.self, json: dict) }
    guard let array = val as? NSArray else { throw Json.Error.UnexpectedType(exp: Array<T>.self, json: val as! JsonType) }
    return try array.map() { try T.init(json: JsonDict(dict: $0 as! NSDictionary)) }
  }
}
