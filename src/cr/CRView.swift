// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRView = NSView
  #else
  import UIKit
  typealias CRView = UIView
#endif


extension CRView {
  
  convenience init(size: CGSize) { self.init(frame: CGRect(size)) }
  
  convenience init(n: String, p: CRView? = nil) {
    self.init(frame: frameInit)
    helpInit(name: n, parent: p)
  }
  
  func helpInit(#name: String, parent: CRView?) {
    self.name = name
    if let p = parent {
      p.addSubview(self)
    }
  }
  
  func addSubviews(subviews: CRView...) {
    for v in subviews {
      addSubview(v)
    }
  }

  var name: String {
    get {
      #if os(OSX)
        return accessibilityIdentifier()
        #else
        return accessibilityIdentifier
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
  
  var huggingH: UILayoutPriority {
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
  
  var huggingV: UILayoutPriority {
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
    
  var compressionH: UILayoutPriority {
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
  
  
  var compressionV: UILayoutPriority {
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
}

