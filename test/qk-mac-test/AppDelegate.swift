// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import AppKit


let viewSize = CGSize(512, 512)

class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!
  var viewController: NSViewController!

  override init() {}

  func applicationDidFinishLaunching(_ note: Notification) {

    let processInfo = ProcessInfo.processInfo()

    // menu bar.
    let quitItem = NSMenuItem(
      title: "Quit " + processInfo.processName,
      action: #selector(NSApplication.terminate(_:)),
      keyEquivalent:"q")

    let appMenu = NSMenu()
    appMenu.addItem(quitItem)

    let appMenuBarItem = NSMenuItem()
    appMenuBarItem.submenu = appMenu

    let menuBar = NSMenu()
    menuBar.addItem(appMenuBarItem)

    let app = NSApplication.shared()
    app.mainMenu = menuBar

    viewController = NSViewController()
    viewController.title = processInfo.processName

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
