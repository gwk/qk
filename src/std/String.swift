// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


let symbolChars = [Character]("_0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzABCDEFG")
let symbolCharsSet = Set(symbolChars)


extension String {
  
  func withoutPathExt() -> String {
    if let r = rangeOfString(".", options: .BackwardsSearch) {
      // TODO: check that the range does not span a slash; allow trailing slash.
      return substringToIndex(r.startIndex)
    } else {
      return self
    }
  }
  
  func replacePathExt(ext: String) -> String {
    var pre: String
    if let r = rangeOfString(".", options: .BackwardsSearch) {
      pre = substringToIndex(r.endIndex)
    } else {
      pre = self + "."
    }
    return pre + ext
  }
  
  var fileUrl: NSURL? { return NSURL(fileURLWithPath: self, isDirectory: false) }

  var dirUrl: NSURL? { return NSURL(fileURLWithPath: self, isDirectory: true) }

  func contains(c: Character) -> Bool {
    for e in self {
      if e == c {
        return true
      }
    }
    return false
  }
  
  func mapChars(transform: (Character) -> Character) -> String {
    var s = ""
    for c in self {
      s.append(transform(c))
    }
    return s
  }
  
  func mapChars(transform: (Character) -> String) -> String {
    var s = ""
    for c in self {
      s.extend(transform(c))
    }
    return s
  }
  
  var asSym: String {
    for c0 in self { // do not actually iterate; just get first element.
      if c0.isDigit {
        return "_" + mapChars() { symbolCharsSet.contains($0) ? $0 : "_" }
      } else {
        return mapChars() { symbolCharsSet.contains($0) ? $0 : "_" }
      }
    }
    return "" // empty case.
  }
  
  var isSym: Bool {
    if isEmpty {
      return false
    }
    var first = true
    for c in self {
      if first {
        if c.isDigit {
          return false
        }
        first = false
      }
      if !symbolCharsSet.contains(c) {
        return false
      }
    }
    return true
  }
  
  // lines.
  
  init(lines: [String]) {
    self = "\n".join(lines)
  }
  
  init(lines: String...) {
    self = "\n".join(lines)
  }

  var lineCount: Int {
    var count = 0
    for c in self {
      if c == "\n" {
        count++
      }
    }
    return count
  }

  var lines: [String] {
    return split(self, allowEmptySlices: true) { $0 == "\n" }
  }
  
  func numberedLinesFrom(from: Int) -> [String] {
    return lines.mapEnum() { i, line in "\((i + from).d(3)): \(line)" }
  }
  
  var numberedLines: [String] { return numberedLinesFrom(1) }
  
  // search.
  
  func partition(seperator: String) -> (String, String)? {
    return nil
  }
  
  
  // unicode.
  
  var codes: UnicodeScalarView { return unicodeScalars }
  
  
  // utf8.
  
  func withUtf8<R>(@noescape body: (UnsafeBufferPointer<UTF8.CodeUnit>) -> R) -> R {
    return nulTerminatedUTF8.withUnsafeBufferPointer(body)
  }
  
  func withUtf8<R>(@noescape body: (UnsafePointer<UTF8.CodeUnit>, Int) -> R) -> R {
    return withUtf8() {
      (bp: UnsafeBufferPointer<UTF8.CodeUnit>) -> R in
      return body(bp.baseAddress, bp.count - 1) // subtract one to omit the null terminator.
    }
  }
}

