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
    case Conversion(exp: Any.Type, json: JsonType)
    case Key(key: String, exp: Any.Type, json: JsonType)
    case Other(ErrorType)
    case Path(String)
    case UnexpectedType(exp: Any.Type, json: JsonType)
  }

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

  static func fromStream<T: JsonType>(stream: NSInputStream, options: NSJSONReadingOptions = []) throws -> T {
    do {
      let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: options) as! JsonType
      if let json = json as? T {
        return json
      } else { throw Error.UnexpectedType(exp: T.self, json: json) }
    } catch let e {
      throw Error.Other(e)
    }
  }

  static func fromPath<T: JsonType>(path: String, options: NSJSONReadingOptions = []) throws -> T {
    guard let stream = NSInputStream(fileAtPath: path) else {
      throw Error.Path(path)
    }
    stream.open()
    return try fromStream(stream, options: options)
  }
}
