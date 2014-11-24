// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit

extension UIAlertView {

  class func show(title: String, _ message: String, _ cancel: String) -> UIAlertView {
    println("alert: \(title); \(message)")
    let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancel)
    alert.show()
    return alert
  }
}
