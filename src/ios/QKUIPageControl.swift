// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


class QKUIPageControl: UIPageControl {
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
  
  convenience init(n: String, p: UIView? = nil, numberOfPages: Int = 5, currentPage: Int = 0) {
    self.init(frame: frameInit)
    helpInit(name: n, parent: p)
    self.numberOfPages = numberOfPages
    self.currentPage = currentPage
  }
  
  // MARK: - QKUISegmentedControl
  
  func helpInit() {
    addTarget(self, action: "handleValueChanged", forControlEvents: .ValueChanged)
  }
  
  func handleValueChanged() { valueChanged() }
  
}