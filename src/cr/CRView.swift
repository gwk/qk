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
}

