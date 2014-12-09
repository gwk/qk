// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


extension NSObject {
  
  var isAccEl: Bool {
    get { return isAccessibilityElement }
    set { isAccessibilityElement = newValue }
  }

  var accLabel: String! {
    get { return accessibilityLabel }
    set { accessibilityLabel = newValue }
  }
  
  var accHint: String! {
    get { return accessibilityHint }
    set { accessibilityHint = newValue }
  }
  
  var accVal: String! {
    get { return accessibilityValue }
    set { accessibilityValue = newValue }
  }
  
  var accTraits: UIAccessibilityTraits {
    get { return accessibilityTraits }
    set { accessibilityTraits = newValue }
  }
  
  var accFrame: CGRect {
    get { return accessibilityFrame }
    set { accessibilityFrame = newValue }
  }
  
  var accPath: UIBezierPath! {
    get { return accessibilityPath }
    set { accessibilityPath = newValue }
  }
  
  //  var accessibilityActivationPoint: CGPoint
  //  var accessibilityLanguage: String!
  //  var accessibilityElementsHidden: Bool
  //  var accessibilityViewIsModal: Bool
  //  var shouldGroupAccessibilityChildren: Bool
  //  var accessibilityNavigationStyle: UIAccessibilityNavigationStyle
}