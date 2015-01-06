// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


var stdButtonColor = CRColor.w
var stdButtonTitleColor = CRColor(l: 0.1)
var stdButtonLitTitleColor = CRColor(0.25, 0.5, 1)
var stdButtonCornerRadius: Flt = 4


class QKUIButton : UIButton {
  
  var touchDown: Action = {}
  var touchUp: Action = {}
  var touchCancel: Action = {}
  
  // MARK: - UIView
  
  required init(coder: NSCoder) {
    // WARNING: archived instances do not preserve any action closures, so we expect them to be set up after decode.
    super.init(coder: coder)
    helpInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    helpInit()
    backgroundColor = stdButtonColor
    titleColor = stdButtonTitleColor
    litTitleColor = stdButtonLitTitleColor
    layer.cornerRadius = stdButtonCornerRadius
  }
  
  convenience init(n: String, p: UIView?, title: String? = nil) {
    self.init(frame: frameInit)
    helpInit(name: n, parent: p)
    self.title = title
  }
  
  // MARK: - QKUIButton
  
  func helpInit() {
    addTarget(self, action: "handleTouchDown", forControlEvents: .TouchDown)
    addTarget(self, action: "handleTouchUp", forControlEvents: .TouchUpInside)
    addTarget(self, action: "handleTouchCancel", forControlEvents: .TouchCancel)
  }
  
  func handleTouchDown() { touchDown() }
  
  func handleTouchUp() { touchUp() }
  
  func handleTouchCancel() { touchCancel() }

}

