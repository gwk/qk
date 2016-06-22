// © 2014 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


enum EventKind {
  case kd
  case ku
  case fc
  case md
  case mu
  case mm
}


class QKResponder: CRResponder {
  //var handlers: [EventKind -> (CREvent, CRView) -> ()] = []

  #if os(OSX)
  override func keyDown(_ e: CREvent) {
    print("QKResponder keyDown: \(e)")
  }
  
  override func keyUp(_ e: CREvent) {
    print("QKResponder keyUp: \(e)")
  }
  
  override func flagsChanged(_ e: CREvent) {
    print("QKResponder flagsChanged: \(e)")
  }
  
  override func mouseDown(_ e: CREvent) {
    print("QKResponder mouseDown: \(e)")
  }
  
  override func mouseUp(_ e: CREvent) {
    print("QKResponder mouseUp: \(e)")
  }
  #endif
}
