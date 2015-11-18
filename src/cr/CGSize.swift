// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGSize {
  
  init(_ w: Flt, _ h: Flt) { self.init(width: w, height: h) }

  // TODO: init<V: VecType2>(_ v: V) // requires that ScalarType be FloatingPointConvertible or something.

  init(_ v: V2) { self.init(width: v.x, height: v.y) }

  init(_ v: V2I) {
    self.init(width: Flt(v.x), height: Flt(v.y))
  }
  
  var w: Flt {
    get { return width }
    set { width = newValue }
  }
  
  var h: Flt {
    get { return height }
    set { height = newValue }
  }
  
  var aspect: Flt { return w / h }
}

func *(a: CGSize, s: Flt) -> CGSize { return CGSize(a.w * s, a.h * s) }
func /(a: CGSize, s: Flt) -> CGSize { return CGSize(a.w / s, a.h / s) }
