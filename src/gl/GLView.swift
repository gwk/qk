// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


class GLView: CRView {

  #if os(OSX)
    override func makeBackingLayer() -> CALayer { return GLLayer() }
    #else
    override class func layerClass() -> AnyClass { return GLLayer }
  #endif

  required init(coder: NSCoder) { fatalError() }
  
  init(n: String, pixFmt: PixFmt) {
    super.init(frame: frameInit)
    self.name = n
    #if os(OSX)
      wantsLayer = true // layer-backed; if we want layer-hosting behavior, set layer explicitly first.
      layer!.autoresizingMask = CAAutoresizingMask(CAAutoresizingMask.LayerWidthSizable.rawValue | CAAutoresizingMask.LayerHeightSizable.rawValue) // ?
      layer!.needsDisplayOnBoundsChange = true // ?
    #endif
    glLayer.setup(pixFmt)
  }

  #if os(OSX)
  override var wantsUpdateLayer: Bool { return true } // updateLayer will get called.
  
  override func updateLayer() {
    glLayer.setNeedsDisplay()
  }
  #endif
  
  var glLayer: GLLayer {
    get { return layer as! GLLayer }
    set { layer = newValue }
  }

  var drawableSize: V2S { return glLayer.drawableSize }
  
  var pixFmt: PixFmt {
    get { return glLayer.pixFmt }
    set { glLayer.pixFmt = newValue }
  }
  
  var renderSetup: GLRenderSetupFn {
    get { return glLayer.renderSetup }
    set { glLayer.renderSetup = newValue }
  }
  
  var render: GLRenderFn {
    get { return glLayer.render }
    set { glLayer.render = newValue }
  }

}
