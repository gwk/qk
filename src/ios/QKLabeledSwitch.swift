// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


class QKLabeledSwitch: UIView {
  
  @IBOutlet var label: UILabel!
  @IBOutlet var switch_: QKUISwitch!
  
  // MARK: - UIView
  
  required init(coder: NSCoder) { fatalError() }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    label = UILabel(name: "label", parent: self)
    switch_ = QKUISwitch(name: "switch", parent: self, isOn: false)
    constrain([label, switch_],
      "H:|[label]-[switch]|",
      "V:|[label]|",
      "V:|[switch]|")
  }
  
  convenience init(name: String, parent: UIView?, title: String? = nil, isOn: Bool = false) {
    self.init(frame: frameInit)
    helpInit(name: name, parent: parent, flex: nil)
    label.text = title
    switch_.on = isOn
  }
}
  
