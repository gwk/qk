// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


// app-wide style variables.
var stdViewColor = CRColor(l: 0.85)


class QKViewController: UIViewController {
  
  required init(coder: NSCoder) { fatalError() }
  
  init() {
    super.init(nibName: nil, bundle: nil)
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
