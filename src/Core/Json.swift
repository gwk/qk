// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol JsonType: AnyObject {}
protocol JsonRootType: JsonType {}
protocol JsonLeafType: JsonType {}

extension NSArray: JsonRootType {}
extension NSDictionary: JsonRootType {}

extension NSNumber: JsonLeafType {}
extension NSString: JsonLeafType {}
extension NSNull: JsonLeafType {}

enum Json {

  typealias _String = Swift.String
  enum Error: ErrorProtocol {
    case conversion(exp: Any.Type, json: JsonType) // error in converting the json value to the expected type.
    case excessEl(index: Int, exp: Any.Type, json: JsonType) // array is too long.
    case key(key: _String, json: JsonType)
    case missingEl(index: Int, json: JsonType) // array is too short.
    case other(ErrorProtocol)
    case path(_String, ErrorProtocol)
    case unexpectedType(exp: Any.Type, json: JsonType)
  }

  //case Null
  //case Number(NSNumber)
  //case String(NSString)
  //case Array(NSArray)
  //case Dictionary(NSDictionary)

  @warn_unused_result
  static func fromData<T: JsonType>(_ data: Data, options: JSONSerialization.ReadingOptions = []) throws -> T {
    let json: JsonType
    do {
      json = try JSONSerialization.jsonObject(with: data, options: options) as! JsonType
    } catch let e {
      throw Error.other(e)
    }
    if let json = json as? T {
      return json
    }
    throw Error.unexpectedType(exp: T.self, json: json)
  }

  @warn_unused_result
  static func fromStream<T: JsonType>(_ stream: InputStream, options: JSONSerialization.ReadingOptions = []) throws -> T {
    let json: JsonType
    do {
      if stream.streamStatus == .notOpen {
        stream.open()
      }
      json = try JSONSerialization.jsonObject(with: stream, options: options) as! JsonType
    } catch let e {
      throw Error.other(e)
    }
    if let json = json as? T {
      return json
    }
    throw Error.unexpectedType(exp: T.self, json: json)
  }

  @warn_unused_result
  static func fromPath<T: JsonType>(_ path: _String, options: JSONSerialization.ReadingOptions = []) throws -> T {
    var data: Data
    do {
      data = try Data(contentsOf: URL(fileURLWithPath: path), options: [.dataReadingUncached])
    } catch let e { throw Error.path(path, e) }
    return try fromData(data, options: options)
  }
}
