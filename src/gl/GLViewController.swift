// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


class GLViewController: CRViewController {
  
  let _initPixFmt: PixFmt
  var scaleFactor: Flt = 0

  required init(coder: NSCoder) { fatalError() }
  
  init!(pixFmt: PixFmt) {
    _initPixFmt = pixFmt
    super.init(nibName: nil, bundle:nil)
  }
  
  override func loadView() {
    view = GLView(n: "GLView", pixFmt: _initPixFmt)
  }
  
  #if os(OSX)
  func updateWindowObserver() {
    noteCenter().removeObserver(self, name: NSWindowDidChangeBackingPropertiesNotification, object: nil)
    noteCenter().addObserver(self,
      selector: "screenDidChange:",
      name: NSWindowDidChangeBackingPropertiesNotification,
      object: view.window!)
    screenDidChange(nil)
  }
  
  func screenDidChange(note: NSNotification?) {
    let screen: NSScreen = view.window!.screen!
    scaleFactor = screen.backingScaleFactor
    println("screenDidChange: \(scaleFactor)")
  }
  #endif
  
  var glView: GLView { return view as! GLView }
  
  var pixFmt: PixFmt {
    get { return glView.pixFmt }
    set { glView.pixFmt = newValue }
  }
  
  var renderSetup: GLRenderSetupFn {
    get { return glView.renderSetup }
    set { glView.renderSetup = newValue }
  }
  
  var render: GLRenderFn {
    get { return glView.render }
    set { glView.render = newValue }
  }
}
