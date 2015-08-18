// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


func check(error: NSError?, @autoclosure message: () -> String, file: StaticString = __FILE__, line: UInt = __LINE__) {
  if let e = error {
    fatalError("\(message())\nerror: \(e)", file: file, line: line)
  }
}
