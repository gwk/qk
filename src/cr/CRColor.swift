// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRColor = NSColor
  #else
  import UIKit
  typealias CRColor = UIColor
#endif


extension CRColor {
  
  class var clear: CRColor  { return self.clearColor(); }
  class var w: CRColor     { return self.whiteColor(); }
  class var k: CRColor     { return self.blackColor(); }
  class var r: CRColor     { return self.redColor(); }
  class var g: CRColor     { return self.greenColor(); }
  class var b: CRColor     { return self.blueColor(); }
  class var c: CRColor     { return self.cyanColor(); }
  class var m: CRColor     { return self.magentaColor(); }
  class var y: CRColor     { return self.yellowColor(); }

  convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) {
    self.init(red: r, green: g, blue: b, alpha: a)
  }

  convenience init(rd: U8, gd: U8, bd: U8, a: CGFloat = 1) {
    self.init(red: Flt(rd) / 255, green: Flt(gd) / 255, blue: Flt(bd) / 255, alpha: a)
  }
  
  convenience init(l: CGFloat, a: CGFloat = 1) {
    self.init(white: l, alpha: a)
  }

  convenience init(r: CGFloat, a: CGFloat=1) { self.init(r, 0, 0, a) }
  convenience init(g: CGFloat, a: CGFloat=1) { self.init(0, g, 0, a) }
  convenience init(b: CGFloat, a: CGFloat=1) { self.init(0, 0, b, a) }

  var a: Flt {
    var l: Flt = 0, a: Flt = 0
    #if os(OSX)
      self.getWhite(&l, alpha: &a)
      #else
      let ok = self.getWhite(&l, alpha: &a)
      assert(ok)
    #endif
    return a
  }
  
  var l: Flt {
    var l: Flt = 0, a: Flt = 0
    #if os(OSX)
      self.getWhite(&l, alpha: &a)
      #else
      let ok = self.getWhite(&l, alpha: &a)
      assert(ok)
    #endif
    return l
  }
  
  var r: Flt {
    var r: Flt = 0, g: Flt = 0, b: Flt = 0, a: Flt = 0
    #if os(OSX)
      self.getRed(&r, green: &g, blue: &b, alpha: &a)
      #else
      let ok = self.getRed(&r, green: &g, blue: &b, alpha: &a)
      assert(ok)
    #endif
    return r
  }
  
  var g: Flt {
    var r: Flt = 0, g: Flt = 0, b: Flt = 0, a: Flt = 0
    #if os(OSX)
      self.getRed(&r, green: &g, blue: &b, alpha: &a)
      #else
      let ok = self.getRed(&r, green: &g, blue: &b, alpha: &a)
      assert(ok)
    #endif
    return g
  }
  
  var b: Flt {
    var r: Flt = 0, g: Flt = 0, b: Flt = 0, a: Flt = 0
    #if os(OSX)
      self.getRed(&r, green: &g, blue: &b, alpha: &a)
      #else
      let ok = self.getRed(&r, green: &g, blue: &b, alpha: &a)
      assert(ok)
    #endif
    return b
  }
  
}
