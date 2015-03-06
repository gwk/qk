// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


class GLView: CRView {
  
  // MARK: - NSResponder
  
  override var acceptsFirstResponder: Bool { return true }
  
  override func mouseDown(event: NSEvent)                 { dispatchEvent(event) }
  override func rightMouseDown(event: NSEvent)            { dispatchEvent(event) }
  override func otherMouseDown(event: NSEvent)            { dispatchEvent(event) }
  override func mouseUp(event: NSEvent)                   { dispatchEvent(event) }
  override func rightMouseUp(event: NSEvent)              { dispatchEvent(event) }
  override func otherMouseUp(event: NSEvent)              { dispatchEvent(event) }
  override func mouseMoved(event: NSEvent)                { dispatchEvent(event) }
  override func mouseDragged(event: NSEvent)              { dispatchEvent(event) }
  override func scrollWheel(event: NSEvent)               { dispatchEvent(event) }
  override func rightMouseDragged(event: NSEvent)         { dispatchEvent(event) }
  override func otherMouseDragged(event: NSEvent)         { dispatchEvent(event) }
  override func mouseEntered(event: NSEvent)              { dispatchEvent(event) }
  override func mouseExited(event: NSEvent)               { dispatchEvent(event) }
  override func keyDown(event: NSEvent)                   { dispatchEvent(event) }
  override func keyUp(event: NSEvent)                     { dispatchEvent(event) }
  override func flagsChanged(event: NSEvent)              { dispatchEvent(event) }
  override func tabletPoint(event: NSEvent)               { dispatchEvent(event) }
  override func tabletProximity(event: NSEvent)           { dispatchEvent(event) }
  override func cursorUpdate(event: NSEvent)              { dispatchEvent(event) }
  override func magnifyWithEvent(event: NSEvent)          { dispatchEvent(event) }
  override func rotateWithEvent(event: NSEvent)           { dispatchEvent(event) }
  override func swipeWithEvent(event: NSEvent)            { dispatchEvent(event) }
  override func beginGestureWithEvent(event: NSEvent)     { dispatchEvent(event) }
  override func endGestureWithEvent(event: NSEvent)       { dispatchEvent(event) }
  override func smartMagnifyWithEvent(event: NSEvent)     { dispatchEvent(event) }
  override func touchesBeganWithEvent(event: NSEvent)     { dispatchEvent(event) }
  override func touchesMovedWithEvent(event: NSEvent)     { dispatchEvent(event) }
  override func touchesEndedWithEvent(event: NSEvent)     { dispatchEvent(event) }
  override func touchesCancelledWithEvent(event: NSEvent) { dispatchEvent(event) }
  override func quickLookWithEvent(event: NSEvent)        { dispatchEvent(event) }
  
  
  #if os(OSX)
  // MARK: - NSView
  
  override func makeBackingLayer() -> CALayer { return GLLayer() }
  
  override var wantsUpdateLayer: Bool { return true } // updateLayer will get called.
  
  override func updateLayer() {
    glLayer.setNeedsDisplay()
  }
  
  #else
  // MARK: - UIView
  
  override class func layerClass() -> AnyClass { return GLLayer }
  #endif
  
  // MARK: - GLView
  
  required init(coder: NSCoder) { fatalError() }
  
  init(n: String, pixFmt: PixFmt) {
    super.init(frame: frameInit)
    self.name = n
    #if os(OSX)
      wantsLayer = true // layer-backed; if we want layer-hosting behavior, set layer explicitly first.
      layer!.autoresizingMask = CAAutoresizingMask(CAAutoresizingMask.LayerWidthSizable.rawValue | CAAutoresizingMask.LayerHeightSizable.rawValue) // ?
      layer!.needsDisplayOnBoundsChange = true // ?
    #endif
    glLayer.setup(pixFmt, view: self)
  }
  
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

  var handleEvent: GLHandleEventFn {
    get { return glLayer.handleEvent }
    set { glLayer.handleEvent = newValue }
  }

  func dispatchEvent(event: CREvent) {
    let glEvent = glEventFrom(event, self)
    switch glEvent {
      case .Ignored: return
      default: handleEvent(glEvent)
    }
  }
}
