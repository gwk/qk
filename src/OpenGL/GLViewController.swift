// © 2014 George King. Permission to use this file is granted in license-qk.txt.

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
  override func screenDidChange(_ note: Notification?) {
  let screen: NSScreen = view.window!.screen!
    scaleFactor = screen.backingScaleFactor
    //println("screenDidChange: \(scaleFactor)")
    view.layer?.contentsScale = scaleFactor
  }
  #endif
  
  var glView: GLView { return view as! GLView }
  
  var pixFmt: PixFmt {
    get { return glView.pixFmt }
    set { glView.pixFmt = newValue }
  }
  
  var render: GLRenderFn {
    get { return glView.render }
    set { glView.render = newValue }
  }

  var handleEvent: GLEventFn {
    get { return glView.handleEvent }
    set { glView.handleEvent = newValue }
  }
}
