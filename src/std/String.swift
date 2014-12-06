// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


import Foundation

extension String {

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

