// © 2014 George King. Permission to use this file is granted in license-qk.txt.

#if os(OSX)
  import AppKit
  #else
  import UIKit
#endif


class GLView: CRView {
  
  // MARK: - NSResponder
  
  override var acceptsFirstResponder: Bool { return true }
  
  override func mouseDown(_ event: NSEvent)                 { dispatchEvent(event) }
  override func rightMouseDown(_ event: NSEvent)            { dispatchEvent(event) }
  override func otherMouseDown(_ event: NSEvent)            { dispatchEvent(event) }
  override func mouseUp(_ event: NSEvent)                   { dispatchEvent(event) }
  override func rightMouseUp(_ event: NSEvent)              { dispatchEvent(event) }
  override func otherMouseUp(_ event: NSEvent)              { dispatchEvent(event) }
  override func mouseMoved(_ event: NSEvent)                { dispatchEvent(event) }
  override func mouseDragged(_ event: NSEvent)              { dispatchEvent(event) }
  override func scrollWheel(_ event: NSEvent)               { dispatchEvent(event) }
  override func rightMouseDragged(_ event: NSEvent)         { dispatchEvent(event) }
  override func otherMouseDragged(_ event: NSEvent)         { dispatchEvent(event) }
  override func mouseEntered(_ event: NSEvent)              { dispatchEvent(event) }
  override func mouseExited(_ event: NSEvent)               { dispatchEvent(event) }
  override func keyDown(_ event: NSEvent)                   { dispatchEvent(event) }
  override func keyUp(_ event: NSEvent)                     { dispatchEvent(event) }
  override func flagsChanged(_ event: NSEvent)              { dispatchEvent(event) }
  override func tabletPoint(_ event: NSEvent)               { dispatchEvent(event) }
  override func tabletProximity(_ event: NSEvent)           { dispatchEvent(event) }
  override func cursorUpdate(_ event: NSEvent)              { dispatchEvent(event) }
  override func magnify(with event: NSEvent)          { dispatchEvent(event) }
  override func rotate(with event: NSEvent)           { dispatchEvent(event) }
  override func swipe(with event: NSEvent)            { dispatchEvent(event) }
  override func beginGesture(with event: NSEvent)     { dispatchEvent(event) }
  override func endGesture(with event: NSEvent)       { dispatchEvent(event) }
  override func smartMagnify(with event: NSEvent)     { dispatchEvent(event) }
  override func touchesBegan(with event: NSEvent)     { dispatchEvent(event) }
  override func touchesMoved(with event: NSEvent)     { dispatchEvent(event) }
  override func touchesEnded(with event: NSEvent)     { dispatchEvent(event) }
  override func touchesCancelled(with event: NSEvent) { dispatchEvent(event) }
  override func quickLook(with event: NSEvent)        { dispatchEvent(event) }
  
  
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
      layer!.autoresizingMask = CAAutoresizingMask(rawValue: CAAutoresizingMask.layerWidthSizable.rawValue | CAAutoresizingMask.layerHeightSizable.rawValue) // ?
      layer!.needsDisplayOnBoundsChange = true // ?
    #endif
    glLayer.setup(pixFmt)
  }
  
  var glLayer: GLLayer {
    get { return layer as! GLLayer }
  }

  var drawableSize: V2S { return glLayer.drawableSize }
  
  var pixFmt: PixFmt {
    get { return glLayer.pixFmt }
    set { glLayer.pixFmt = newValue }
  }
  
  var render: GLRenderFn {
    get { return glLayer.render }
    set { glLayer.render = newValue }
  }

  var handleEvent: GLEventFn {
    get { return glLayer.handleEvent }
    set { glLayer.handleEvent = newValue }
  }

  func dispatchEvent(_ event: CREvent) {
    let glEvent = glEventFrom(event, view: self)
    switch glEvent {
      case .ignored: return
      default: handleEvent(glEvent)
    }
  }
}
