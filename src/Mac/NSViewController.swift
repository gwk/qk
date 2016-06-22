// © 2016 George King. Permission to use this file is granted in license.txt.

import AppKit


extension NSViewController {

  func updateWindowObserver() {
    noteCenter().removeObserver(self, name: NSNotification.Name.NSWindowDidChangeBackingProperties, object: nil)
    noteCenter().addObserver(self,
                             selector: #selector(screenDidChange),
                             name: NSNotification.Name.NSWindowDidChangeBackingProperties,
                             object: view.window!)
    screenDidChange(nil)
  }
  
  func screenDidChange(_ note: Notification?) {}
}
