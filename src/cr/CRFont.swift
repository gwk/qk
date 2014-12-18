// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRFont = NSFont
  #else
  import UIKit
  typealias CRFont = UIFont
#endif


extension CRFont {
#if os(OSX)
  var lineHeight: Flt { return (ascender - descender) + leading }
#endif
}
