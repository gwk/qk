// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation

enum EventKind {
  case KD
  case KU
}


class QKResponder: CRResponder {
  //var handlers: [EventKind -> (CREvent, CRView) -> ()] = []
  
  override func keyDown(e: CREvent) {
    println("QKResponder keyDown: \(e)")
  }
  
  override func keyUp(e: CREvent) {
    println("QKResponder keyUp: \(e)")
  }
  
  override func flagsChanged(e: CREvent) {
    println("QKResponder flagsChanged: \(e)")
  }
  
  override func mouseDown(e: CREvent) {
    println("QKResponder mouseDown: \(e)")
  }
  
  override func mouseUp(e: CREvent) {
    println("QKResponder mouseUp: \(e)")
  }
  
}