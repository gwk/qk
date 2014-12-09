// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIViewController {
  
  var nav: UINavigationController? { return navigationController }
  
  func present(c: UIViewController, animated: Bool = true, completion: Action? = nil) {
    (nav as UIViewController?).or(self).presentViewController(c, animated: animated, completion: completion)
  }
  
  func presentNavRoot(root: UIViewController, animated: Bool = true, completion: Action? = nil) {
    root.navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: root.closeButtonTitle,
      style: .Plain,
      target: root,
      action:"dismissSelfAction")
    let n = UINavigationController(rootViewController: root)
    present(n, animated: animated, completion: completion)
  }
  
  func dismissPresented(animated: Bool = true, completion: Action? = nil) {
    dismissViewControllerAnimated(animated, completion: completion)
  }
  
  func dismissSelf(animated: Bool = true, completion: Action? = nil) {
    if let c = presentingViewController {
      c.dismissPresented(animated: animated, completion: completion)
    } else {
      println("dismissSelf: no presenting controller: \(self)")
    }
  }

  func dismissSelfAction() { dismissSelf() }
  
  var closeButtonTitle: String {
    return "Close"
  }
}

