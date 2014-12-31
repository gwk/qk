// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


class QKUIButton : UIButton {
  
  var touchDown: Action?
  var touchUp: Action?
  var touchCancel: Action?
  
  // MARK: - UIView
  
  required init(coder: NSCoder) {
    // WARNING: archived instances do not preserve any action closures, so we expect them to be set up after decode.
    super.init(coder: coder)
    addActions()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frameInit)
    addActions()
  }
  
  convenience init(n: String) {
    self.init(frame: frameInit)
    name = n
  }
  
  // MARK: - QKUIButton
  
  func addActions() {
    addTarget(self, action: "handleTouchDown", forControlEvents: .TouchDown)
    addTarget(self, action: "handleTouchUp", forControlEvents: .TouchUpInside)
    addTarget(self, action: "handleTouchCancel", forControlEvents: .TouchCancel)
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

