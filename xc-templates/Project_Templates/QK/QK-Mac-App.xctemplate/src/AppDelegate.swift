// © 2015 AUTHOR. All rights reserved.

import Cocoa

let viewSize = CGSize(512, 512)

class AppDelegate: NSObject, NSApplicationDelegate {
  
  var window: NSWindow!
  var viewController: ViewController!

  override init() {}
  
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

    viewController = ViewController()
    viewController.title = "TITLE"

    window = NSWindow(
      origin: CGPoint(0, 0),
      viewSize: viewSize,
      fixedAspect: true,
      viewController: viewController)
    window.contentMinSize = viewSize
    window.contentMaxSize = viewSize
    window.makeKeyAndOrderFront(nil)
  }
}
