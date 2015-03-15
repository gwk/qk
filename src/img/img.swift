// Copyright 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


func lumRepr(#img: [U8], #imgSize: V2I, #offset: V2I, #size: V2I, maxWidth: Int = 64) -> String {
  var s = ""
  for j in 0..<size.y {
    let y = offset.y + j
    for i in 0..<min(size.x, maxWidth) {
      let x = offset.x + i
      assert(x < imgSize.x)
      assert(y < imgSize.y)
      var val = Int(img[y * imgSize.x + x])
      var si = (val == 0) ? "--" : (val == 255 ? "||" : val.h0(2))
      s.extend(si)
    }
    if size.x > maxWidth {
      s.extend("~")
    }
    s.extend("\n")
  }
  return s
}
