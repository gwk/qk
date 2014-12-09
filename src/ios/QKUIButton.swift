// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


class QKUIButton : UIButton {
  
  var touchDown: Action?
  var touchUp: Action?
  var touchCancel: Action?
  
  required init(coder: NSCoder) { fatalError("NSCoding not supported") }
  
  override init(frame: CGRect) {
    super.init(frame: frameInit)
    addTarget(self, action: "handleTouchDown", forControlEvents: .TouchDown)
    addTarget(self, action: "handleTouchUp", forControlEvents: .TouchUpInside)
    addTarget(self, action: "handleTouchCancel", forControlEvents: .TouchCancel)
  }
  
  convenience init(n: String) {
    self.init(frame: frameInit)
    name = n
  }
  
  func handleTouchDown() {
    if let a = touchDown {
      a()
    }
  }
  
  func handleTouchUp() {
    if let a = touchUp {
      a()
    }
  }
  
  func handleTouchCancel() {
    if let a = touchCancel {
      a()
    }
  }
  
}

