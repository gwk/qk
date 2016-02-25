// © 2016 George King. Permission to use this file is granted in license.txt.

import AppKit


extension NSViewController {

  func updateWindowObserver() {
    noteCenter().removeObserver(self, name: NSWindowDidChangeBackingPropertiesNotification, object: nil)
    noteCenter().addObserver(self,
                             selector: #selector(screenDidChange),
                             name: NSWindowDidChangeBackingPropertiesNotification,
                             object: view.window!)
    screenDidChange(nil)
  }
  
  func screenDidChange(note: NSNotification?) {}
}
