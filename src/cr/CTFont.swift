// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import CoreText


extension CTFont {


  static func with(name: String, pointSize: Flt, matrix: CGAffineTransform = CGAffineTransformIdentity) -> CTFont {
    var matrix = matrix
    return CTFontCreateWithName(name, pointSize, &matrix)
  }

  var pointSize: Flt { return CTFontGetSize(self) }

  var matrix: CGAffineTransform { return CTFontGetMatrix(self) }

  
}
