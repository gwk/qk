// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


class QKUISlider: UISlider {
  var valueChanged: Action = {}

  // MARK: - UIView

  required init(coder: NSCoder) { fatalError() }

  override init(frame: CGRect) {
    super.init(frame: frame)
    helpInit()
  }

  // MARK: - QKUISlider

  func helpInit() {
    addTarget(self, action: "handleValueChanged", forControlEvents: .ValueChanged)
  }

  func handleValueChanged() { valueChanged() }

}


