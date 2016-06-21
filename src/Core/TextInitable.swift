// © 2016 George King. Permission to use this file is granted in license-qk.txt.


let textOctChars = Set("01234567".characters)
let textDecChars = Set("0123456789".characters)
let textHexChars = Set("0123456789ABCDEFabcdef".characters)
let textSymHeadChars = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".characters)
let textSymTailChars = textSymHeadChars.union(textDecChars).union(["_"])
let textFloatChars = textDecChars.union(["."])

struct TextInitableError: ErrorType {
  let line: Int
  let col: Int
  let msg: String
  let text: String
}

protocol TextInitableIntegerType {
  init?(_ text: String, radix: Int)
}

extension TextInitableIntegerType {
  init(text: String, pos: String.CharacterView.Index, end: String.CharacterView.Index, line: Int, col: Int) throws {
    var p = pos
    while p != end {
      if !textDecChars.contains(text[p]) {
        break
      }
      p = p.successor()
    }
    let t = text[pos..<p]
    if let result = Self(t, radix: 10) {
      self = result
    } else {
      throw TextInitableError(line: line, col: col, msg: "invalid text for Int", text: t)
    }
  }
}

protocol TextInitable {
  init(text: String, pos: String.CharacterView.Index, end: String.CharacterView.Index, line: Int, col: Int) throws
}

extension Int: TextInitableIntegerType, TextInitable {}
extension Uns: TextInitableIntegerType, TextInitable {}
extension I8: TextInitableIntegerType, TextInitable {}
extension U8: TextInitableIntegerType, TextInitable {}
extension I16: TextInitableIntegerType, TextInitable {}
extension U16: TextInitableIntegerType, TextInitable {}
extension I32: TextInitableIntegerType, TextInitable {}
extension U32: TextInitableIntegerType, TextInitable {}
extension I64: TextInitableIntegerType, TextInitable {}
extension U64: TextInitableIntegerType, TextInitable {}

extension String: TextInitable {
  init(text: String, pos: String.CharacterView.Index, end: String.CharacterView.Index, line: Int, col: Int) throws {
    self = text[pos..<end]
  }
}
