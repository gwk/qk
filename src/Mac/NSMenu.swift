// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import AppKit


extension NSMenu {

  convenience init(parentItem: NSMenuItem) {
    self.init()
    parentItem.submenu = self
  }

  convenience init(superMenu: NSMenu) {
    self.init()
    let parentItem = NSMenuItem(parent: superMenu)
    parentItem.submenu = self
  }
}