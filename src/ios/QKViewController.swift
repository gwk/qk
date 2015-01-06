// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


// app-wide style variables.
var stdViewColor: CRColor = CRColor(l:0.9)


class QKViewController: UIViewController {
  
  required init(coder: NSCoder) { fatalError() }
  
  override init(nibName: String? = nil, bundle: NSBundle? = nil) {
    super.init(nibName: nibName, bundle: bundle)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = stdViewColor
  }
  
}