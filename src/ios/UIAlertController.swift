// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


typealias UIAlertActionHandler = (UIAlertAction) -> ()

extension UIAlertController {

  convenience init(title: String, message: String, style: UIAlertControllerStyle = .Alert, actionTitle: String = "OK", handler: UIAlertActionHandler? = nil) {
    self.init(title: title, message: message, preferredStyle: style)
    let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: handler)
    addAction(defaultAction)
  }
}

