// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


let symbolChars = [Character]("_0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzABCDEFG")
let symbolCharsSet = mapToDict(symbolChars) { ($0, true) }


extension String {
  
  func removePathExt() -> String {
    if let r = rangeOfString(".", options: .BackwardsSearch) {
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

  //func split<S : Sliceable, R : BooleanType>(elements: S, isSeparator: (S.Generator.Element) -> R, maxSplit: Int = default, allowEmptySlices: Bool = default) -> [S.SubSlice]

  var lines: [String] {
    return split(self, { c in c == "\n" }, allowEmptySlices: true)
  }
  
  func numberedLinesFrom(from: Int) -> [String] {
    return lines.mapEnum() { i, line in "\((i + from).d(3)): \(line)" }
  }
  
  var numberedLines: [String] { return numberedLinesFrom(1) }
  
}

