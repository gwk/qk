// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


class QKUIBarButtonItem: UIBarButtonItem {

  var touchAction: Action = {}
  
  // MARK: - UIView
  
  required init(coder: NSCoder) {
    // WARNING: archived instances do not preserve any action closures, so we expect them to be set up after decode.
    super.init(coder: coder)
    helpInit()
  }
  
  init(style: UIBarButtonItemStyle = .Plain, title: String? = nil, image: UIImage? = nil, landscapeImage: UIImage? = nil, touchAction: Action? = nil) {
    super.init()
    helpInit()
    self.style = style
    self.title = title
    self.image = image
    self.landscapeImagePhone = landscapeImage
    if let a = touchAction {
      self.touchAction = a
    }
  }
  
  // MARK: - QKUIButton
  
  func helpInit() {
    target = self
    action = "handleAction"
  }
  
  func handleAction() { touchAction() }

}
