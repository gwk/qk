// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


extension UISearchBar {
  var isEmpty: Bool {
    if let text = text {
      return text.isEmpty
    } else {
      return true
    }
  }
}
