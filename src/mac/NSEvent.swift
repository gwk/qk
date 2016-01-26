// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Cocoa


let unicodeArrowUp    = UnicodeScalar(0xF700)
let unicodeArrowDown  = UnicodeScalar(0xF701)
let unicodeArrowLeft  = UnicodeScalar(0xF702)
let unicodeArrowRight = UnicodeScalar(0xF703)


extension NSEvent {

  var unicodeScalar: UnicodeScalar {
    let scalars = charactersIgnoringModifiers!.unicodeScalars
    assert(scalars.count == 1)
    return scalars.first!
  }

}
