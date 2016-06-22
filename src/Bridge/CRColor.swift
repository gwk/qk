// © 2014 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  typealias CRColor = NSColor
  #else
  import UIKit
  typealias CRColor = UIColor
#endif


extension CRColor {
  
  class var clear: CRColor  { return self.clear(); }
  class var w: CRColor     { return self.white(); }
  class var k: CRColor     { return self.black(); }
  class var r: CRColor     { return self.red(); }
  class var g: CRColor     { return self.green(); }
  class var b: CRColor     { return self.blue(); }
  class var c: CRColor     { return self.cyan(); }
  class var m: CRColor     { return self.magenta(); }
  class var y: CRColor     { return self.yellow(); }

  convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) {
    self.init(red: r, green: g, blue: b, alpha: a)
  }

  convenience init(ur: U8, ug: U8, ub: U8, a: CGFloat = 1) {
    self.init(red: Flt(ur) / 0xff, green: Flt(ug) / 0xff, blue: Flt(ub) / 0xff, alpha: a)
  }
  
  convenience init(l: CGFloat, a: CGFloat = 1) {
    self.init(white: l, alpha: a)
  }

  convenience init(r: CGFloat, a: CGFloat=1) { self.init(r, 0, 0, a) }
  convenience init(g: CGFloat, a: CGFloat=1) { self.init(0, g, 0, a) }
  convenience init(b: CGFloat, a: CGFloat=1) { self.init(0, 0, b, a) }

  convenience init(v2S v: V2S) {
    self.init(l: Flt(v.x), a: Flt(v.y))
  }

  convenience init(v3S v: V3S) {
    self.init(red: Flt(v.x), green: Flt(v.y), blue: Flt(v.z), alpha: 1)
  }

  convenience init(v4S v: V4S) {
    self.init(red: Flt(v.x), green: Flt(v.y), blue: Flt(v.z), alpha: Flt(v.w))
  }

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
