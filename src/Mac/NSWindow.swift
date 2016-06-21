// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import AppKit


extension NSWindow {

  convenience init(
    origin: CGPoint = CGPoint(0, 0),
    viewSize: CGSize,
    fixedAspect: Bool = false,
    styleMask: Int = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask,
    deferred: Bool = false,
    screen: NSScreen? = nil,
    viewController: NSViewController) {

      self.init(
        contentRect: CGRectZero, // gets clobbered by controller view initial size.
        styleMask: styleMask,
        backing: NSBackingStoreType.Buffered, // the only modern mode.
        defer: deferred,
        screen: screen)

      contentViewController = viewController
      bind(NSTitleBinding, toObject: viewController, withKeyPath: "title", options: nil)
      self.origin = origin
      setContentSize(viewSize)
      if fixedAspect {
        contentAspectRatio = viewSize
      }
  }

  var viewSize: CGSize {
    get {
      return contentRectForFrameRect(frame).size
    }
    set {
      setContentSize(newValue)
    }
  }
}