// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol IntegerInitable {
  init(_ v: Int)
  init(_ v: Uns)
  init(_ v: I8)
  init(_ v: U8)
  init(_ v: I16)
  init(_ v: U16)
  init(_ v: I32)
  init(_ v: U32)
  init(_ v: I64)
  init(_ v: U64)
}


extension Int: IntegerInitable {}
extension Uns: IntegerInitable {}
extension I8: IntegerInitable {}
extension U8: IntegerInitable {}
extension I16: IntegerInitable {}
extension U16: IntegerInitable {}
extension I32: IntegerInitable {}
extension U32: IntegerInitable {}
extension I64: IntegerInitable {}
extension U64: IntegerInitable {}
