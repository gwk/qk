// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRResponder = NSResponder
  #else
  import UIKit
  typealias CRResponder = UIResponder
#endif


extension CRResponder {
  
  #if os(OSX)
  func insertNextResponder(responder: CRResponder) {
    responder.nextResponder = self.nextResponder
    self.nextResponder = responder
  }
  #endif
}
