// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


let symbolHeadChars = Set<Character>("_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".characters)
let symbolTailChars = symbolHeadChars.union("0123456789".characters)

let symbolHeadCharsSet = Set(symbolHeadChars)
let symbolTailCharsSet = Set(symbolTailChars)


extension String {

  init(char: Character, count: Int) {
    // repeating:count: is overloaded, so character literals fail as ambiguous.
    self.init(repeating: char, count: count)
  }
  
  init(indent: Int) {
    self.init(char: " ", count: indent * 2)
  }
  
  // MARK: paths

  var pathExtDotRange: Range<Index>?    { return range(of: ".", options: .backwardsSearch) }
  var pathDirSlashRange: Range<Index>?  { return range(of: "/", options: .backwardsSearch) }

  var pathExt: String {
    if let r = pathExtDotRange {
      return substring(from: r.lowerBound)
    } else {
      return ""
    }
  }

  var withoutPathExt: String {
    if let r = pathExtDotRange {
      // TODO: check that the range does not span a slash.
      // TODO: allow trailing slash.
      return substring(to: r.lowerBound)
    } else {
      return self
    }
  }
  
  @warn_unused_result
  func replacePathExt(_ ext: String) -> String {
    var pre: String
    if let r = pathExtDotRange {
      pre = substring(to: r.upperBound)
    } else {
      pre = self + "."
    }
    return pre + ext
  }

  var pathDir: String {
    if let r = pathDirSlashRange {
      return substring(to: r.lowerBound)
    } else {
      return ""
    }
  }

  var withoutPathDir: String {
    if let r = pathDirSlashRange {
      return substring(from: r.upperBound)
    } else {
      return self
    }
  }

  var pathNameStem: String {
    return withoutPathDir.withoutPathExt
  }
  
  // MARK: urls
  
  var fileUrl: URL? { return URL(fileURLWithPath: self, isDirectory: false) }

  var dirUrl: URL? { return URL(fileURLWithPath: self, isDirectory: true) }

  // MARK: utilities
  
  @warn_unused_result
  func contains(_ c: Character) -> Bool {
    for e in self.characters {
      if e == c {
        return true
      }
    }
    return false
  }
  
  @warn_unused_result
  func has(_ query: String, atIndex: Index) -> Bool {
    return characters.has(query.characters, atIndex: atIndex)
  }

  @warn_unused_result
  func beforeSuffix(_ suffix: String) -> String? {
    if hasSuffix(suffix) {
      return String(self.characters.dropLast(suffix.characters.count))
    } else {
      return nil
    }
  }

  @warn_unused_result
  func mapChars(_ transform: (Character) -> Character) -> String {
    var s = ""
    for c in self.characters {
      s.append(transform(c))
    }
    return s
  }
  
  @warn_unused_result
  func mapChars(_ transform: (Character) -> String) -> String {
    var s = ""
    for c in self.characters {
      s.append(transform(c))
    }
    return s
  }
  
  @warn_unused_result
  func replace(_ query: Character, with: Character) -> String {
    return String(characters.replace(query, with: with))
  }
  
  @warn_unused_result
  func replace(_ query: String, with: String) -> String {
    return String(characters.replace(query.characters, with: with.characters))
  }
  
  var dashToUnder: String { return replace(Character("-"), with: Character("_")) }
  
  // MARK: symbols
  
  var asSym: String { // TODO: decide if this should be strict; currently quite lax.
    for c0 in self.characters { // do not actually iterate; just get first element.
      if c0.isDigit {
        return "_" + mapChars() { symbolTailCharsSet.contains($0) ? $0 : "_" }
      } else {
        return mapChars() { symbolTailCharsSet.contains($0) ? $0 : "_" }
      }
    }
    return "" // empty case.
  }
  
  var isSym: Bool { // TODO: decide if this should be strict; currently quite lax.
    if isEmpty {
      return false
    }
    var first = true
    for c in self.characters {
      if first {
        if c.isDigit {
          return false
        }
        first = false
      }
      if !symbolTailCharsSet.contains(c) {
        return false
      }
    }
    return true
  }
  
  // MARK: lines
  
  init(lines: [String]) {
    self = lines.joined(separator: "\n")
  }
  
  init(lines: String...) {
    self = lines.joined(separator: "\n")
  }

  var lineCount: Int {
    var count = 0
    for c in self.characters {
      if c == "\n" {
        count += 1
      }
    }
    return count
  }

  var lines: [String] {
    let charLines = self.characters.split(separator: "\n", omittingEmptySubsequences: false)
    return charLines.map { String($0) }
  }
  
  @warn_unused_result
  func numberedLinesFrom(_ from: Int) -> [String] {
    return lines.enumerated().map() { (i, line) in " \(line)" }
  }
  
  var numberedLines: [String] { return numberedLinesFrom(1) }
    
  
  // MARK: unicode
  
  var codes: UnicodeScalarView { return unicodeScalars }
  
  
  // MARK: utf8
  
  func asUtf8<R>(_ body: @noescape (UnsafeBufferPointer<UTF8.CodeUnit>) -> R) -> R {
    return nulTerminatedUTF8.withUnsafeBufferPointer(body)
  }
  
  func asUtf8<R>(_ body: @noescape (UnsafePointer<UTF8.CodeUnit>, Int) -> R) -> R {
    return asUtf8() {
      (bp: UnsafeBufferPointer<UTF8.CodeUnit>) -> R in
      return body(bp.baseAddress!, bp.count - 1) // subtract one to omit the null terminator.
    }
  }
  
  // MARK: partition
  
  @warn_unused_result
  func part(_ sep: String) -> (String, String)? {
    if let (a, b) = characters.part(sep.characters) {
      return (String(a), String(b))
    }
    return nil
  }

  @warn_unused_result
  func split(_ separator: Character) -> [String] {
    return characters.split(separator: separator).map() { String($0) }
  }

  /* TODO
  func split(sub: String) -> [String] {
    return characters.split(separator: sub.characters).map() { String($0) }
  }
 */
}

