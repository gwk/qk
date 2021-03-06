// © 2014 George King. Permission to use this file is granted in license-qk.txt.


let digitChars = [Character]("0123456789abcdef".characters)

extension Int {

  @warn_unused_result
  func repr(_ base: Int = 10, pad: Character = " ", width: Int = 0) -> String {
    if self == 0 {
      let count = Swift.max(0, width - 1)
      return String(repeating: pad, count: count) + "0"
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
      pad_len -= 1
    }
    return String(Array(a.reversed()))
  }

  @warn_unused_result
  func dec(_ width: Int) -> String { return self.repr(10, width: width) }

  @warn_unused_result
  func hex(_ width: Int) -> String { return self.repr(16, width: width) }
  
  var dec: String { return self.dec(0) }
  var hex: String { return self.hex(0) }
  
  @warn_unused_result
  func dec0(_ width: Int) -> String { return self.repr(10, pad: "0", width: width) }

  @warn_unused_result
  func hex0(_ width: Int) -> String { return self.repr(16, pad: "0", width: width) }
}
