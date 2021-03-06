// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


class QKUISwitch: UISwitch {
  var valueChanged: Action = {}
  
  // MARK: - UIView
  
  required init(coder: NSCoder) { fatalError() }

  override init(frame: CGRect) {
    super.init(frame: frame)
    helpInit()
  }
  
  convenience init(name: String, parent: UIView? = nil, isOn: Bool = false) {
    self.init(frame: frameInit)
    helpInit(name: name, parent: parent, flex: nil)
    self.on = isOn
  }
  
  // MARK: - QKUISegmentedControl
  
  func helpInit() {
    addTarget(self, action: "handleValueChanged", forControlEvents: .ValueChanged)
  }
  
  func handleValueChanged() { valueChanged() }
  
}
