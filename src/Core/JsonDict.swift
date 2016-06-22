// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonDictInitable {
  init(jsonDict: JsonDict) throws
}


extension JsonDictInitable {
  init(json: JsonType) throws {
    let jsonDict = try JsonDict(json: json)
    try self.init(jsonDict: jsonDict)
  }
}


protocol JsonDictItemInitable {
  init(key: String, json: JsonType) throws
}


extension JsonType {
  func asDict() throws -> JsonDict {
    guard let d = self as? NSDictionary else {
      throw Json.Error.unexpectedType(exp: JsonDict.self, json: self)
    }
    return JsonDict(raw: d)
  }

  func convDict<T: JsonDictInitable>() throws -> T {
    return try T(jsonDict: try asDict())
  }
}


struct JsonDict: JsonInitable {
  let raw: NSDictionary

  init(raw: NSDictionary) { self.raw = raw }

  init(json: JsonType) throws {
    if let raw = json as? NSDictionary {
      self.init(raw: raw)
    } else { throw Json.Error.unexpectedType(exp: NSDictionary.self, json: json) }
  }

  init(data: Data) throws { self.init(raw: try Json.fromData(data)) }

  init(stream: InputStream) throws { self.init(raw: try Json.fromStream(stream)) }

  init(path: String) throws { self.init(raw: try Json.fromPath(path)) }

  subscript(key: String) -> JsonType? {
    return raw[key] as! JsonType?
  }

  @warn_unused_result
  func contains(_ key: String) -> Bool {
    return raw[key] != nil
  }

  @warn_unused_result
  func get(_ key: String) throws -> JsonType {
    guard let val = raw[key] else { throw Json.Error.key(key: key, json: raw) }
    return val as! JsonType
  }

  @warn_unused_result
  func convItems<T: JsonDictItemInitable>() throws -> [T] {
    return try raw.map { try T.init(key: $0.0 as! String, json: $0.1 as! JsonType) }
  }

  @warn_unused_result
  func mapVals<V>(transform: (JsonType) throws -> V) rethrows -> [String:V] {
    var d: [String:V] = [:]
    for (k, v) in raw {
      d[k as! String] = try transform(v as! JsonType)
    }
    return d
  }
}
