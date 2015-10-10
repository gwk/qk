// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonDictConvertible {
  init(json: JsonDict) throws
}


struct JsonDict {
  let dict: NSDictionary

  init(dict: NSDictionary) { self.dict = dict }

  init(data: NSData) throws { self.init(dict: try Json.fromData(data)) }

  init(stream: NSInputStream) throws { self.init(dict: try Json.fromStream(stream)) }

  init(path: String) throws { self.init(dict: try Json.fromPath(path)) }

  func get<T: JsonConvertible>(key: String) throws -> T {
  guard let val = dict[key] else { throw Json.Error.Key(key: key, exp: T.self, json: dict) }
  return try T.init(json: val as! JsonType)
  }

  func array<T: JsonConvertible>(key: String) throws -> [T] {
    guard let val = dict[key] else { throw Json.Error.Key(key: key, exp: Array<T>.self, json: dict) }
    guard let array = val as? NSArray else { throw Json.Error.UnexpectedType(exp: Array<T>.self, json: val as! JsonType) }
    return try array.map() { try T.init(json: $0 as! JsonType) }
  }

  func array<T: JsonDictConvertible>(key: String) throws -> [T] {
    guard let val = dict[key] else { throw Json.Error.Key(key: key, exp: Array<T>.self, json: dict) }
    guard let array = val as? NSArray else { throw Json.Error.UnexpectedType(exp: Array<T>.self, json: val as! JsonType) }
    return try array.map() { try T.init(json: JsonDict(dict: $0 as! NSDictionary)) }
  }
}

/*

extension NSDictionary {
}

func jsonOrNil<T: JsonConvertible>(key: NSString) throws -> T? {
guard let val = self[key] as? T else { return nil }
return try T.init(json: val as! JsonType)
}
}
*/