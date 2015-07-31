// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


let digitChars = [Character]("0123456789abcdef".characters)

extension Int {

  func repr(base: Int = 10, pad: Character = " ", width: Int = 0) -> String {
    if self == 0 {
      return String(count: width, repeatedValue: pad)
    }
    var a = [Character]()
    let neg = (self < 0)
    var i = neg ? -self : self
    while i != 0 {
      let d = i % base
      a.append(digitChars[d])
      i /= base
    }
    var pad_len = width - (a.count + (neg ? 1 : 0))
    if neg {
      a.append("-")
    }
    while pad_len > 0 {
      a.append(pad)
      pad_len--
    }
    return String(Array(a.reverse()))
  }

  func dec(width: Int) -> String { return self.repr(10, width: width) }
  func hex(width: Int) -> String { return self.repr(16, width: width) }
  
  var dec: String { return self.dec(0) }
  var hex: String { return self.hex(0) }
  
  func dec0(width: Int) -> String { return self.repr(10, pad: "0", width: width) }
  func hex0(width: Int) -> String { return self.repr(16, pad: "0", width: width) }
}
