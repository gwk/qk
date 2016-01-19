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

  enum Error: ErrorType {
    case Conversion(exp: Any.Type, json: JsonType) // error in converting the json value to the expected type.
    case Key(key: String, exp: Any.Type, json: JsonType)
    case MissingEl(index: Int, exp: Any.Type, json: JsonType) // array is too short.
    case Other(ErrorType)
    case Path(String, ErrorType)
    case UnexpectedType(exp: Any.Type, json: JsonType)
  }

  @warn_unused_result
  static func fromData<T: JsonType>(data: NSData, options: NSJSONReadingOptions = []) throws -> T {
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(data, options: options) as! JsonType
      if let json = json as? T {
        return json
      } else { throw Error.UnexpectedType(exp: T.self, json: json) }
    } catch let e {
      throw Error.Other(e)
    }
  }

  @warn_unused_result
  static func fromStream<T: JsonType>(stream: NSInputStream, options: NSJSONReadingOptions = []) throws -> T {
    do {
      if stream.streamStatus == .NotOpen {
        stream.open()
      }
      let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: options) as! JsonType
      if let json = json as? T {
        return json
      } else { throw Error.UnexpectedType(exp: T.self, json: json) }
    } catch let e {
      throw Error.Other(e)
    }
  }

  @warn_unused_result
  static func fromPath<T: JsonType>(path: String, options: NSJSONReadingOptions = []) throws -> T {
    var data: NSData
    do {
      data = try NSData(contentsOfFile: path, options: [.DataReadingUncached])
    } catch let e { throw Error.Path(path, e) }
    return try fromData(data, options: options)
  }
}
