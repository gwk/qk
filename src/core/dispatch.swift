// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


// values from dispatch/source.h.
enum DispatchFileMode: Uns {
  case Delete = 0x01 // DISPATCH_VNODE_DELETE
  case Write  = 0x02 // DISPATCH_VNODE_WRITE
  case Extend = 0x04 // DISPATCH_VNODE_EXTEND
  case Attrib = 0x08 // DISPATCH_VNODE_ATTRIB
  case Link   = 0x10 // DISPATCH_VNODE_LINK
  case Rename = 0x20 // DISPATCH_VNODE_RENAME
  case Revoke = 0x40 // DISPATCH_VNODE_REVOKE
}


struct DispatchFileModes: OptionSetType {
  typealias OptionType = DispatchFileMode
  let val: Uns
  init(_ val: Uns) { self.val = val }
  init(_ opt: DispatchFileMode) { self.val = opt.rawValue }
  
  static var all: DispatchFileModes = union(.Delete, .Write, .Extend, .Attrib, .Link, .Rename, .Revoke)
}


func outLLA(items: [String]) {
  dispatch_async(dispatch_get_main_queue()) {
    for i in items {
      println(i)
    }
  }
}

func outLLA(items: String...) { outLLA(items) }
