// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSObject {

  class var dynamicClassFullName: String { return NSStringFromClass(self) }
  
  class var dynamicClassName: String {
    return NSString(string: dynamicClassFullName).pathExtension // TODO: implement pathExtension for String.
  }
  
  var dynamicTypeFullName: String { return NSStringFromClass(self.dynamicType) }

  var dynamicTypeName: String {
    return NSString(string: dynamicTypeFullName).pathExtension // TODO: implement pathExtension for String.
  }
}
