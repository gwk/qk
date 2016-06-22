// © 2015 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CREdgeInsets = EdgeInsets
  #else
  import UIKit
  typealias CREdgeInsets = UIEdgeInsets
#endif


extension CREdgeInsets {

  var l: Flt { return left }
  var t: Flt { return top }
  var r: Flt { return right }
  var b: Flt { return bottom }
  
  init(l: Flt = 0, t: Flt = 0, r: Flt = 0, b: Flt = 0) {
    self.init(top: t, left: l, bottom: b, right: r)
  }
}
