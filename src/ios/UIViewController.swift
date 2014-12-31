// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIViewController {
  
  var nav: UINavigationController? { return navigationController }
  
  class func fromStoryboard() -> UIViewController {
    let s = NSStringFromClass(self)
    let r = s.rangeOfString(".")!
    let n = s.substringFromIndex(r.endIndex)
    println("fromStoryboard: \(n)")
    let board = UIStoryboard(name: n, bundle: nil)
    return board.instantiateInitialViewController() as UIViewController
  }
  
  func present(c: UIViewController, animated: Bool = true, completion: Action? = nil) {
    // TODO: should this be parentViewController instead of just nav?
    (nav as UIViewController?).or(self).presentViewController(c, animated: animated, completion: completion)
  }
  
  func presentNavRoot(root: UIViewController, isBarHidden: Bool = false, animated: Bool = true, completion: Action? = nil) {
    root.navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: root.closeButtonTitle,
      style: .Plain,
      target: root,
      action:"dismissSelfAction")
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

  func dismissSelfAction() { dismissSelf() }
  
  var closeButtonTitle: String {
    return "Close"
  }
}

