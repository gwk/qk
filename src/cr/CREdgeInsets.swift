// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CREdgeInsets = NSEdgeInsets
  #else
  import UIKit
  typealias CREdgeInsets = UIEdgeInsets
#endif


extension CREdgeInsets {

  init(l: Flt = 0, t: Flt = 0, r: Flt = 0, b: Flt = 0) {
    self.init(top: t, left: l, bottom: b, right: r)
  }
}
