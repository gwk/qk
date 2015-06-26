// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRWindow = NSWindow
  #else
  import UIKit
  typealias CRWindow = UIWindow
#endif



extension CRWindow {

  #if os(OSX)
  var origin: CGPoint { // top-left point.
    get {
      var sh: Flt
      if let s = screen {
        sh = s.visibleFrame.size.height
      } else {
        sh = 0
      }
      let f = frame
      return CGPoint(f.origin.x, sh - (f.origin.y + f.size.height))
    }
    set {
      var sh: Flt
      if let s = screen {
        sh = s.visibleFrame.size.height
      } else {
        sh = 0
      }
      let f = frame
      // note: setFrameOriginTopLeft does not work as advertised on 10.10.
      setFrameOrigin(CGPoint(newValue.x, sh - (newValue.y + f.size.height)))
    }
  }

  var size: CGSize {
    get { return contentRectForFrameRect(frame).size }
    set { setContentSize(newValue) }
  }
  #endif
}

