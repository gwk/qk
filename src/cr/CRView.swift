// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRView = NSView
  #else
  import UIKit
  typealias CRView = UIView
#endif


#if os(OSX)
  // TODO: use NSAccessibilityIdentifierAttribute?
  
var _viewTagNames: [String] = [""]
var _viewNameTags: [String:Int] = ["":0]

func regViewNameTag(n: String) -> Int {
  assert(_viewTagNames.count == _viewNameTags.count)
  let ot = _viewNameTags[n]
  if let t = ot {
    assert(n == _viewTagNames[t])
    return t
  } else {
    let c = _viewTagNames.count
    _viewTagNames.append(n)
    _viewNameTags[n] = c
    return c
  }
}
#endif

extension CRView {
  
  convenience init(size: CGSize) { self.init(frame: CGRect(size)) }
  
  convenience init(n: String) {
    self.init(frame: frameInit)
    self.name = n
  }
  
  var name: String {
    get {
      #if os(OSX)
        return _viewTagNames[tag]
        #else
        return accessibilityIdentifier
      #endif
    }
    set {
      assert(newValue.isSym)
      #if os(OSX)
        tag = regViewNameTag(newValue)
      #else
        accessibilityIdentifier = newValue
      #endif
    }
  }
}

