// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSMutableData {

  func append<T>(_ el: T) { var el = el; self.append(&el, length: sizeof(T)) }
}

