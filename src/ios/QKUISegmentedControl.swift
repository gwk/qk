// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


class QKUISegmentedControl: UISegmentedControl {
  var valueChanged: Action = {}
  
  // MARK: - UIView
  
  required init(coder: NSCoder) {
    // WARNING: archived instances do not preserve any action closures, so we expect them to be set up after decode.
    super.init(coder: coder)
    helpInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    helpInit()
  }
  
  convenience init(n: String, p: UIView?, titles: [String]) {
    self.init(frame: frameInit)
    helpInit(name: n, parent: p)
    for (i, t) in enumerate(titles) {
      self.insertSegmentWithTitle(t, atIndex: i, animated: false)
    }
  }
  
  convenience init(n: String, p: UIView?, titles: String...) {
    self.init(n: n, p: p, titles: titles)
  }
  
  // MARK: - QKUISegmentedControl
  
  func helpInit() {
    addTarget(self, action: "handleValueChanged", forControlEvents: .ValueChanged)
  }
  
  func handleValueChanged() { valueChanged() }

}