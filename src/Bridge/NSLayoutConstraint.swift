// © 2014 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


extension NSLayoutAttribute {
  
  var isSome: Bool { return self != .NotAnAttribute }
}
