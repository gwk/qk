// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


// app-wide style variables.
var stdViewColor: CRColor = CRColor(l: 0.85)


class QKViewController: UIViewController {
  
  required init(coder: NSCoder) { super.init(coder: coder) }
  
  override init(nibName: String? = nil, bundle: NSBundle? = nil) {
    super.init(nibName: nibName, bundle: bundle)
    if title == nil {
      #if DEBUG
        title = dynamicTypeName // set the title to the class name as a convenience while prototyping.
      #endif
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    #if DEBUG
    view.name = "_" + dynamicTypeName + "_view_"
    #endif
    view.backgroundColor = stdViewColor
  }
  
}
