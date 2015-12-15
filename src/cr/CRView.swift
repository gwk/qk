// © 2014 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRView = NSView
  typealias CRFlex = NSAutoresizingMaskOptions
  typealias CRAxis = NSLayoutConstraintOrientation
  typealias CRPriority = NSLayoutPriority
  #else
  import UIKit
  typealias CRView = UIView
  typealias CRFlex = UIViewAutoresizing
  typealias CRAxis = UILayoutConstraintAxis
  typealias CRPriority = UILayoutPriority
#endif


extension CRFlex {

  #if os(OSX)
  static var N: CRFlex { return ViewNotSizable }
  static var W: CRFlex { return ViewWidthSizable }
  static var H: CRFlex { return ViewHeightSizable }
  static var L: CRFlex { return ViewMinXMargin }
  static var R: CRFlex { return ViewMaxXMargin }
  static var T: CRFlex { return ViewMinYMargin }
  static var B: CRFlex { return ViewMaxYMargin }
  #else
  static var N: CRFlex { return None }
  static var W: CRFlex { return FlexibleWidth }
  static var H: CRFlex { return FlexibleHeight }
  static var L: CRFlex { return FlexibleLeftMargin }
  static var R: CRFlex { return FlexibleRightMargin }
  static var T: CRFlex { return FlexibleTopMargin }
  static var B: CRFlex { return FlexibleBottomMargin }
  #endif
  
  static var Size: CRFlex { return [W, H] }
  static var Hori: CRFlex { return [L, R] }
  static var Vert: CRFlex { return [T, B] }
  static var Pos: CRFlex { return [Hori, Vert] }
  static var WL: CRFlex { return [W, L] }
  static var WR: CRFlex { return [W, R] }
}


extension CRView {

  
  convenience init(frame: CGRect, name: String, parent: CRView? = nil, flex: CRFlex? = nil) {
    self.init(frame: frame)
    helpInit(name: name, parent: parent, flex: flex)
  }

  convenience init(frame: CGRect, parent: CRView, flex: CRFlex? = nil) {
    self.init(frame: frame)
    helpInit(name: nil, parent: parent, flex: flex)
  }
  
  convenience init(size: CGSize, name: String? = nil, parent: CRView? = nil, flex: CRFlex? = nil) {
    self.init(frame: CGRect(size))
    helpInit(name: name, parent: parent, flex: flex)
  }
  
  convenience init(name: String, parent: CRView? = nil, flex: CRFlex? = nil) {
    self.init(frame: frameInit)
    helpInit(name: name, parent: parent, flex: flex)
  }
  
  func helpInit(name name: String?, parent: CRView?, flex: CRFlex?) {
    if let name = name {
      self.name = name
    }
    if let parent = parent {
      parent.addSubview(self)
    }
    if let flex = flex {
      self.flex = flex
    }
  }
  
  func addSubviews(subviews: CRView...) {
    for v in subviews {
      addSubview(v)
    }
  }
  
  func removeAllSubviews() {
    for v in subviews {
      v.removeFromSuperview()
    }
  }

  var name: String {
    get {
      #if os(OSX)
        return accessibilityIdentifier()
        #else
        return accessibilityIdentifier!
      #endif
    }
    set {
      assert(newValue.isSym)
      #if os(OSX)
        setAccessibilityIdentifier(newValue)
        #else
        accessibilityIdentifier = newValue
      #endif
    }
  }

  func describeTree(depth: Int = 0) {
    err(String(count: depth, repeatedValue: Character(" ")))
    errL(description)
  }

  var flex: CRFlex {
    get { return autoresizingMask }
    set { autoresizingMask = newValue }
  }
  
  var o: CGPoint {
    get { return frame.origin }
    set { frame.origin = newValue }
  }
  
  var s: CGSize {
    get { return frame.size }
    set { frame.size = newValue }
  }
  
  var x: CGFloat {
    get { return frame.origin.x }
    set { frame.origin.x = newValue }
  }
  
  var y: CGFloat {
    get { return frame.origin.y }
    set { frame.origin.y = newValue }
  }
  
  var w: CGFloat {
    get { return frame.size.width }
    set { frame.size.width = newValue }
  }
  
  var h: CGFloat {
    get { return frame.size.height }
    set { frame.size.height = newValue }
  }
  
  var r: CGFloat {
    get { return x + w }
    set { x = newValue - w }
  }
  
  var b: CGFloat {
    get { return y + h }
    set { y = newValue - h }
  }
  
  var c: CGPoint {
    get {
      #if os(OSX)
        return CGPoint(x + (0.5 * w), y + (0.5 * h))
      #else
        return center
      #endif
    }
    set {
      #if os(OSX)
        o = CGPoint(newValue.x - (0.5 * w), newValue.y - (0.5 * h))
        #else
        center = newValue
      #endif
    }
  }
  
  var huggingH: CRPriority {
    get {
      #if os(OSX)
        return contentHuggingPriorityForOrientation(.Horizontal)
        #else
        return contentHuggingPriorityForAxis(.Horizontal)
      #endif
    }
    set {
      #if os(OSX)
        return setContentHuggingPriority(huggingH, forOrientation: .Horizontal)
        #else
        return setContentHuggingPriority(huggingH, forAxis: .Horizontal)
      #endif
    }
  }
  
  var huggingV: CRPriority {
    get {
      #if os(OSX)
        return contentHuggingPriorityForOrientation(.Vertical)
        #else
        return contentHuggingPriorityForAxis(.Vertical)
      #endif
    }
    set {
      #if os(OSX)
        return setContentHuggingPriority(huggingV, forOrientation: .Vertical)
        #else
        return setContentHuggingPriority(huggingV, forAxis: .Vertical)
      #endif
    }
  }
    
  var compressionH: CRPriority {
    get {
      #if os(OSX)
        return contentCompressionResistancePriorityForOrientation(.Horizontal)
        #else
        return contentCompressionResistancePriorityForAxis(.Horizontal)
      #endif
    }
    set {
      #if os(OSX)
        return setContentCompressionResistancePriority(compressionH, forOrientation: .Horizontal)
        #else
        return setContentCompressionResistancePriority(compressionH, forAxis: .Horizontal)
      #endif
    }
  }
  
  var compressionV: CRPriority {
    get {
      #if os(OSX)
        return contentCompressionResistancePriorityForOrientation(.Vertical)
        #else
        return contentCompressionResistancePriorityForAxis(.Vertical)
      #endif
    }
    set {
      #if os(OSX)
        return setContentCompressionResistancePriority(compressionV, forOrientation: .Vertical)
        #else
        return setContentCompressionResistancePriority(compressionV, forAxis: .Vertical)
      #endif
    }
  }
  
  #if os(OSX)
    func setNeedsDisplay() { needsDisplay = true }
  #endif
}

