// © 2015 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRFontDescriptor = NSFontDescriptor
  let CRFontAttrFixedAdvance = NSFontFixedAdvanceAttribute
  #else
  import UIKit
  typealias CRFontDescriptor = UIFontDescriptor
  let CRFontAttrFixedAdvance = UIFontDescriptorFixedAdvanceAttribute
#endif



extension CRFontDescriptor {
  var attributes: [String : AnyObject] {
    #if os(OSX)
      return fontAttributes
      #else
      return fontAttributes()
    #endif
  }
}
