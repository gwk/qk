// © 2015 George King. All rights reserved.

import AppKit
import SpriteKit


class ViewController: NSViewController {

  // MARK: NSResponder

  override func keyDown(event: NSEvent) {
    guard let string = event.charactersIgnoringModifiers else {
      super.keyDown(event)
      return
    }
    switch string {
    default: super.keyDown(event)
    }
  }

  // MARK: NSViewController

  override func loadView() {
    view = NSView()
  }

  override func viewWillAppear() {
    errL("viewWillAppear")
  }

  override func viewDidAppear() {
    errL("viewDidAppear")
  }

  // MARK: ViewController

  required init(coder: NSCoder) { fatalError() }

  init() {
    super.init(nibName: nil, bundle: nil)!
  }
}
