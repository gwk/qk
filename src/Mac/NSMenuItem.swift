// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import AppKit


extension NSMenuItem {

  convenience init(parent: NSMenu) {
    self.init()
    parent.addItem(self)
  }
}