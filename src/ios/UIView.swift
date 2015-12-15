// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIView {
  
  class func fromNib(name: String, owner: AnyObject) -> [AnyObject] {
    return NSBundle.mainBundle().loadNibNamed(name, owner: owner, options: nil)
  }

  func loadSubviewsFromNib(var owner: NSObject? = nil, var name: String? = nil) {
    if owner == nil {
      owner = self
    }
    if name == nil {
      name = owner!.dynamicTypeName
    }
    let subviews = UIView.fromNib(name!, owner: owner!)
    for v in subviews {
      addSubview(v as! UIView)
    }
  }
}

