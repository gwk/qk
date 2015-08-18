// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIButton {
  
  var image: UIImage? {
    get { return imageForState(.Normal) }
    set { setImage(newValue, forState: .Normal) }
  }
  
  var backgroundImage: UIImage? {
    get { return backgroundImageForState(.Normal) }
    set { setBackgroundImage(newValue, forState: .Normal) }
  }
  
  var litBackgroundImage: UIImage? {
    get { return backgroundImageForState(.Highlighted) }
    set { setBackgroundImage(newValue, forState: .Highlighted) }
  }
  
  var disabledBackgroundImage: UIImage? {
    get { return backgroundImageForState(.Disabled) }
    set { setBackgroundImage(image, forState: .Disabled) }
  }
  
  var title: String? {
    get { return titleForState(.Normal) }
    set { setTitle(newValue, forState: .Normal) }
  }
  
  var litTitle: String? {
    get { return titleForState(.Highlighted) }
    set { setTitle(newValue, forState: .Highlighted) }
  }
  
  var attrTitle: NSAttributedString? {
    get { return attributedTitleForState(.Normal) }
    set { setAttributedTitle(newValue, forState: .Normal) }
  }
  
  var litAttrTitle: NSAttributedString? {
    get { return attributedTitleForState(.Highlighted) }
    set { setAttributedTitle(newValue, forState: .Highlighted) }
  }
  
  var titleColor: UIColor? {
    get { return titleColorForState(.Normal) }
    set { setTitleColor(newValue, forState: .Normal) }
  }
  
  var litTitleColor: UIColor? {
    get { return titleColorForState(.Highlighted) }
    set { setTitleColor(newValue, forState: .Highlighted) }
  }
  
  var disabledTitleColor: UIColor? {
    get { return titleColorForState(.Disabled) }
    set { setTitleColor(newValue, forState: .Disabled) }
  }
  
  func addTarget(target: AnyObject, action: Selector) {
    addTarget(target, action: action, forControlEvents: .TouchUpInside)
  }

}

