// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


class QKUIPageControl: UIPageControl {
  var valueChanged: Action = {}
  
  // MARK: - UIView
  
  required init(coder: NSCoder) { fatalError() }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    helpInit()
  }
  
  convenience init(name: String, parent: UIView? = nil, numberOfPages: Int = 5, currentPage: Int = 0) {
    self.init(frame: frameInit)
    helpInit(name: name, parent: parent, flex: nil)
    self.numberOfPages = numberOfPages
    self.currentPage = currentPage
  }
  
  // MARK: - QKUISegmentedControl
  
  func helpInit() {
    addTarget(self, action: "handleValueChanged", forControlEvents: .ValueChanged)
  }
  
  func handleValueChanged() { valueChanged() }
  
}
