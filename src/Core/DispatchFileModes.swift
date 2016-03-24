// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


struct DispatchFileModes: OptionSet, CustomStringConvertible {
  
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
  static var loadable: DispatchFileModes = [Write, Extend, Rename, Revoke]

  var description: String {
    var strings: [String] = []
    if self.contains(DispatchFileModes.Delete) { strings.append("Delete") }
    if self.contains(DispatchFileModes.Write)  { strings.append("Write") }
    if self.contains(DispatchFileModes.Extend) { strings.append("Extend") }
    if self.contains(DispatchFileModes.Attrib) { strings.append("Attrib") }
    if self.contains(DispatchFileModes.Rename) { strings.append("Rename") }
    if self.contains(DispatchFileModes.Revoke) { strings.append("Revoke") }
    return "[(\(strings.joinWithSeparator(", "))]"
  }
}
