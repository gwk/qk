// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSObject {

  class var dynamicClassFullName: String { return NSStringFromClass(self) }
  
  class var dynamicClassName: String {
    return dynamicClassFullName.pathExtension
  }
  
  var dynamicTypeFullName: String { return NSStringFromClass(self.dynamicType) }

  var dynamicTypeName: String {
    return dynamicTypeFullName.pathExtension
  }
}
