// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import AppKit


let initWindowSize = CGSize(512, 256)

class AppDelegate: NSObject, NSApplicationDelegate {
  
  weak var window: NSWindow!
  var viewController: NSViewController!

  func applicationDidFinishLaunching(note: NSNotification) {
    
    let processInfo = NSProcessInfo.processInfo()
    
    // menu bar.
    let quitItem = NSMenuItem(
      title: "Quit " + processInfo.processName,
      action: Selector("terminate:"),
      keyEquivalent:"q")
    
    let appMenu = NSMenu()
    appMenu.addItem(quitItem)
    
    let appMenuBarItem = NSMenuItem()
    appMenuBarItem.submenu = appMenu
    
    let menuBar = NSMenu()
    menuBar.addItem(appMenuBarItem)
    
    let app = NSApplication.sharedApplication()
    app.mainMenu = menuBar
    
    viewController = NSViewController()
    viewController.title = processInfo.processName
    
    window = NSWindow(
      contentRect: CGRectZero, // arbitrary; gets clobbered by controller view initial size.
      styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask,
      backing: NSBackingStoreType.Buffered,
      `defer`: false)
    window.contentViewController = viewController
    window.bind(NSTitleBinding, toObject:viewController, withKeyPath:"title", options:nil)
    //viewController.updateWindowObserver()
    
    window.origin = CGPoint(8, 48)
    window.size = initWindowSize
    window.makeKeyAndOrderFront(nil)
  }
}

