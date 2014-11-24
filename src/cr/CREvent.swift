// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CREvent = NSEvent
  #else
  import UIKit
  typealias CREvent = UIEvent
#endif
