// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension Character {

  var isDigit: Bool { return "0123456789".contains(self) }

  // unicode.
  
  var codes: String.UnicodeScalarView { return String(self).unicodeScalars }
  
  var code: UnicodeScalar {
    for c in codes { return c }
    return UnicodeScalar(0) // never reached.
  }
}
