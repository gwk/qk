// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


extension UINavigationItem {
  
  func addBackItem(title: String = "Back") {
    backBarButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
  }
}
