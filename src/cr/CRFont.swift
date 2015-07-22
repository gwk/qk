// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRFont = NSFont
  typealias CRFontDescriptor = NSFontDescriptor
  let CRFontAttrFixedAdvance = NSFontFixedAdvanceAttribute
  #else
  import UIKit
  typealias CRFont = UIFont
  typealias CRFontDescriptor = UIFontDescriptor
  let CRFontAttrFixedAdvance = UIFontDescriptorFixedAdvanceAttribute
#endif


extension CRFont {
#if os(OSX)
  var lineHeight: Flt { return (ascender - descender) + leading }
#endif
  
  var fixedAdvance: Flt {
    let attrs = fontDescriptor().fontAttributes()
    if let advanceVal: AnyObject = attrs[CRFontAttrFixedAdvance] {
      return Flt(advanceVal as! NSNumber)
    } else {
      return 0
    }
  }
}
