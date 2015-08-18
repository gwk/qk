// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIViewController {
  
  var nav: UINavigationController? { return navigationController }
  
  class func fromStoryboard() -> UIViewController {
    let board = UIStoryboard(name: dynamicClassName, bundle: nil)
    return board.instantiateInitialViewController() as UIViewController
  }
  
  func present(c: UIViewController, animated: Bool = true, completion: Action? = nil) {
    // TODO: should this be parentViewController instead of just nav?
    (nav as UIViewController?).or(self).presentViewController(c, animated: animated, completion: completion)
  }
  
  func presentNavRoot(root: UIViewController, dismissTitle: String? = "Close", isBarHidden: Bool = false, animated: Bool = true,
    completion: Action? = nil) {
      if let title = dismissTitle {
        root.navigationItem.leftBarButtonItem = UIBarButtonItem(
          title: title,
          style: .Plain,
          target: root,
          action:"dismissSelfAction")
      }
      let n = UINavigationController(rootViewController: root)
      n.navigationBarHidden = isBarHidden
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
  
  func dismissSelfAction() { dismissSelf() } // wrapper for objc action selectors.
}

