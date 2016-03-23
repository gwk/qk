// © 2014 George King. Permission to use this file is granted in license-qk.txt.

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
  
  var descriptor: CRFontDescriptor {
    #if os(OSX)
      return fontDescriptor
      #else
      return fontDescriptor()
    #endif
  }
  
  var fixedAdvance: Flt {
    if let advanceVal: AnyObject = descriptor.attributes[CRFontAttrFixedAdvance] {
      return Flt(advanceVal as! NSNumber)
    } else {
      return 0
    }
  }
}
