// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRView = NSView
  #else
  import UIKit
  typealias CRView = UIView
#endif


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


extension CRView {
  
  convenience init(size: CGSize) { self.init(frame: CGRect(size)) }
  
  convenience init(n: String) {
    self.init(frame: frameInit)
    self.name = n
  }
  
  var name: String {
    get { return _viewTagNames[tag] }
    set {
      assert(newValue.isSym)
      tag = regViewNameTag(newValue)
      #if os(OSX)
      // TODO: accessibilityIdentifier?
      #else
        accLabel = newValue // for now, unconditionally update the value.
      #endif
    }
  }
}

