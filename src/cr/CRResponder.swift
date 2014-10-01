// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import AppKit

typealias CRResponder = NSResponder


extension CRResponder {
  
  func insertNextResponder(responder: CRResponder) {
    responder.nextResponder = self.nextResponder
    self.nextResponder = responder
  }

}