// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRViewController = NSViewController
  #else
  import UIKit
  typealias CRViewController = UIViewController
#endif

