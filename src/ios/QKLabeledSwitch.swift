// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


class QKLabeledSwitch: UIView {
  
  @IBOutlet var label: UILabel!
  @IBOutlet var switch_: QKUISwitch!
  
  // MARK: - UIView
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    label = UILabel(n: "label", p: self)
    switch_ = QKUISwitch(n: "switch", p: self)
    constrain([label, switch_],
      "H:|[label]-[switch]|",
      "V:|[label]|",
      "V:|[switch]|")
  }
  
  convenience init(n: String, p: UIView?, title: String? = nil, isOn: Bool = false) {
    self.init(frame: frameInit)
    helpInit(name: n, parent: p)
    label.text = title
    switch_.on = isOn
  }
}
  