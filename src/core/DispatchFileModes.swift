// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Dispatch


struct DispatchFileModes: OptionSetType {
  
  let rawValue: Uns
  
  init(rawValue: Uns) { self.rawValue = rawValue }
  
  // values from dispatch/source.h.
  static let Delete = DispatchFileModes(rawValue: DISPATCH_VNODE_DELETE)
  static let Write  = DispatchFileModes(rawValue: DISPATCH_VNODE_WRITE)
  static let Extend = DispatchFileModes(rawValue: DISPATCH_VNODE_EXTEND)
  static let Attrib = DispatchFileModes(rawValue: DISPATCH_VNODE_ATTRIB)
  static let Link   = DispatchFileModes(rawValue: DISPATCH_VNODE_LINK)
  static let Rename = DispatchFileModes(rawValue: DISPATCH_VNODE_RENAME)
  static let Revoke = DispatchFileModes(rawValue: DISPATCH_VNODE_REVOKE)
  
  static var all: DispatchFileModes = [Delete, Write, Extend, Attrib, Link, Rename, Revoke]
}


