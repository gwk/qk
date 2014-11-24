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
   
}
