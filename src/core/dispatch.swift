// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


struct DispatchFileModes: OptionSetType {

  let rawValue: Uns
  
  init(rawValue: Uns) { self.rawValue = rawValue }

  // values from dispatch/source.h.
  static let Delete = DispatchFileModes(rawValue: 0x01) // DISPATCH_VNODE_DELETE
  static let Write  = DispatchFileModes(rawValue: 0x02) // DISPATCH_VNODE_WRITE
  static let Extend = DispatchFileModes(rawValue: 0x04) // DISPATCH_VNODE_EXTEND
  static let Attrib = DispatchFileModes(rawValue: 0x08) // DISPATCH_VNODE_ATTRIB
  static let Link   = DispatchFileModes(rawValue: 0x10) // DISPATCH_VNODE_LINK
  static let Rename = DispatchFileModes(rawValue: 0x20) // DISPATCH_VNODE_RENAME
  static let Revoke = DispatchFileModes(rawValue: 0x40) // DISPATCH_VNODE_REVOKE

  static var all: DispatchFileModes = [Delete, Write, Extend, Attrib, Link, Rename, Revoke]
}


func outLLA(items: [String]) {
  dispatch_async(dispatch_get_main_queue()) {
    for i in items {
      print(i)
    }
  }
}

func outLLA(items: String...) { outLLA(items) }
