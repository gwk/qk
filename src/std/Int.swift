// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


let digitChars = [Character]("0123456789abcdef")

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
    while pad_len > 0 {
      a.append(pad)
      pad_len--
    }
    if neg {
      a.append("-")
    }
    a.reverse()
    return String(a)
  }

  func d(width: Int) -> String { return self.repr(base: 10, width: width) }
  func h(width: Int) -> String { return self.repr(base: 16, width: width) }
  
  var d: String { return self.d(0) }
  var h: String { return self.h(0) }
  
  func d0(width: Int) -> String { return self.repr(base: 10, pad: "0", width: width) }
  func h0(width: Int) -> String { return self.repr(base: 16, pad: "0", width: width) }
  
  var d0: String { return self.d(0) }
  var h0: String { return self.h(0) }
}
