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
  static var N: CRFlex { return NSAutoresizingMaskOptions() }
  static var W: CRFlex { return viewWidthSizable }
  static var H: CRFlex { return viewHeightSizable }
  static var L: CRFlex { return viewMinXMargin }
  static var R: CRFlex { return viewMaxXMargin }
  static var T: CRFlex { return viewMinYMargin }
  static var B: CRFlex { return viewMaxYMargin }
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
  
  func helpInit(name: String?, parent: CRView?, flex: CRFlex?) {
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
  
  func addSubviews(_ subviews: CRView...) {
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

  func describeTree(_ depth: Int = 0) {
    err(String(repeating: Character(" "), count: depth))
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
        return contentHuggingPriority(for: .horizontal)
        #else
        return contentHuggingPriorityForAxis(.Horizontal)
      #endif
    }
    set {
      #if os(OSX)
        return setContentHuggingPriority(huggingH, for: .horizontal)
        #else
        return setContentHuggingPriority(huggingH, forAxis: .Horizontal)
      #endif
    }
  }
  
  var huggingV: CRPriority {
    get {
      #if os(OSX)
        return contentHuggingPriority(for: .vertical)
        #else
        return contentHuggingPriorityForAxis(.Vertical)
      #endif
    }
    set {
      #if os(OSX)
        return setContentHuggingPriority(huggingV, for: .vertical)
        #else
        return setContentHuggingPriority(huggingV, forAxis: .Vertical)
      #endif
    }
  }
    
  var compressionH: CRPriority {
    get {
      #if os(OSX)
        return contentCompressionResistancePriority(for: .horizontal)
        #else
        return contentCompressionResistancePriorityForAxis(.Horizontal)
      #endif
    }
    set {
      #if os(OSX)
        return setContentCompressionResistancePriority(compressionH, for: .horizontal)
        #else
        return setContentCompressionResistancePriority(compressionH, forAxis: .Horizontal)
      #endif
    }
  }
  
  var compressionV: CRPriority {
    get {
      #if os(OSX)
        return contentCompressionResistancePriority(for: .vertical)
        #else
        return contentCompressionResistancePriorityForAxis(.Vertical)
      #endif
    }
    set {
      #if os(OSX)
        return setContentCompressionResistancePriority(compressionV, for: .vertical)
        #else
        return setContentCompressionResistancePriority(compressionV, forAxis: .Vertical)
      #endif
    }
  }
  
  #if os(OSX)
    func setNeedsDisplay() { needsDisplay = true }
  #endif
}

