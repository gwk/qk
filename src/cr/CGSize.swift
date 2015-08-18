// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGSize {
  
  init(_ w: Flt, _ h: Flt) { self.init(width: w, height: h) }
  
  static let zero = CGSize.zeroSize
  
  var w: Flt {
    get { return width }
    set { width = newValue }
  }
  
  var h: Flt {
    get { return height }
    set { height = newValue }
  }
}

