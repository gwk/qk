// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSObject {

  class var dynamicClassFullName: String { return NSStringFromClass(self) }
  
  class var dynamicClassName: String {
    let p = dynamicClassFullName
    let r = p.rangeOfString(".")!
    return p.substringFromIndex(r.endIndex)
  }
  
  var dynamicTypeFullName: String { return NSStringFromClass(self.dynamicType) }

  var dynamicTypeName: String {
    let p = dynamicTypeFullName
    let r = p.rangeOfString(".")!
    return p.substringFromIndex(r.endIndex)
  }
}
