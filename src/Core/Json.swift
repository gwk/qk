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
    case Conversion(exp: Any.Type, json: JsonType) // error in converting the json value to the expected type.
    case ExcessEl(index: Int, exp: Any.Type, json: JsonType) // array is too long.
    case Key(key: _String, json: JsonType)
    case MissingEl(index: Int, json: JsonType) // array is too short.
    case Other(ErrorProtocol)
    case Path(_String, ErrorProtocol)
    case UnexpectedType(exp: Any.Type, json: JsonType)
  }

  //case Null
  //case Number(NSNumber)
  //case String(NSString)
  //case Array(NSArray)
  //case Dictionary(NSDictionary)

  @warn_unused_result
  static func fromData<T: JsonType>(data: NSData, options: NSJSONReadingOptions = []) throws -> T {
    let json: JsonType
    do {
      json = try NSJSONSerialization.JSONObjectWithData(data, options: options) as! JsonType
    } catch let e {
      throw Error.Other(e)
    }
    if let json = json as? T {
      return json
    }
    throw Error.UnexpectedType(exp: T.self, json: json)
  }

  @warn_unused_result
  static func fromStream<T: JsonType>(stream: NSInputStream, options: NSJSONReadingOptions = []) throws -> T {
    let json: JsonType
    do {
      if stream.streamStatus == .NotOpen {
        stream.open()
      }
      json = try NSJSONSerialization.JSONObjectWithStream(stream, options: options) as! JsonType
    } catch let e {
      throw Error.Other(e)
    }
    if let json = json as? T {
      return json
    }
    throw Error.UnexpectedType(exp: T.self, json: json)
  }

  @warn_unused_result
  static func fromPath<T: JsonType>(path: _String, options: NSJSONReadingOptions = []) throws -> T {
    var data: NSData
    do {
      data = try NSData(contentsOfFile: path, options: [.DataReadingUncached])
    } catch let e { throw Error.Path(path, e) }
    return try fromData(data, options: options)
  }
}
