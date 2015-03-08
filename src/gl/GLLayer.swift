// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import QuartzCore

#if os(OSX)
  typealias CRGLLayer = CAOpenGLLayer
  #else
  typealias CRGLLayer = CAEAGLLayer
#endif


typealias GLRenderFn = (F32, V2S, Time) -> ()
typealias GLEventFn = (GLEvent) -> ()

  
class GLLayer: CRGLLayer {

  required init(coder: NSCoder) { fatalError() }
  
  override init() { super.init() } // layer gets instantiated for us on iOS, so we must defer initialization to setup().

  var drawableSize = V2S()
  var needsInitialLayerTime = true
  var initialLayerTime: Time = 0
  var prevLayerTime: Time = 0
  
  var pixFmt: PixFmt = .None {
    willSet { assert(pixFmt == .None, "GLLayer: altering the pixFmt is not yet supported") }
  }
  
  var render: GLRenderFn = { (time) in () } {
    didSet {}
  }
  
  var handleEvent: GLEventFn = { (CREvent) in () }
  
  #if os(iOS)
  var context: EAGLContext!
  var frameBuffer: GLuint = 0
  var renderBuffer: GLuint = 0
  var depthBuffer: GLuint = 0
  var displayLink: CADisplayLink!
  #endif
  
  func setup(pixFmt: PixFmt) {
    self.pixFmt = pixFmt
    opaque = true
    opacity = 1
    asynchronous = false
    #if os(iOS)
      context = EAGLContext(API: kEAGLRenderingAPIOpenGLES2)
      check(context != nil)
      check(EAGLContext.setCurrentContext(context)) // in case host does not support ES2
      drawableProperties = [
        // once the render buffer is presented, its contents may be altered by OpenGL, and therefore must be completely redrawn.
        // TODO: respect pixFmt.
        kEAGLDrawablePropertyRetainedBacking : NSNumber(false),
        kEAGLDrawablePropertyColorFormat : NSNumber(kEAGLColorFormatRGBA8)]
    #endif
  }
  
  #if os(OSX)
  
  // CAOpenGLLayer.
  
  override func copyCGLPixelFormatForDisplayMask(mask: U32) -> CGLPixelFormatObj {
    typealias PFA = CGLPixelFormatAttribute
    var attrs: [PFA] = []
    attrs.append(kCGLPFADoubleBuffer)
    attrs.append(kCGLPFAColorSize)
    attrs.append(PFA(U32(pixFmt.cglColorSize)))
    attrs.append(kCGLPFAAlphaSize)
    attrs.append(PFA(U32(pixFmt.alphaSize)))
    attrs.append(kCGLPFADepthSize)
    attrs.append(PFA(U32(pixFmt.depthSize)))
    if (pixFmt.isF32) {
      attrs.append(kCGLPFAColorFloat)
    }
    let ms = pixFmt.multisamples
    if (ms > 0) {
      attrs.append(kCGLPFASampleBuffers)
      attrs.append(PFA(1))
      attrs.append(kCGLPFAMultisample)
      attrs.append(kCGLPFASamples)
      attrs.append(PFA(U32(ms)))
      //kCGLPFASampleAlpha?
    }
    //kCGLPFAAcceleratedCompute.
    attrs.append(PFA(0)) // null terminator
    
    var pf: CGLPixelFormatObj = nil
    var virtualScreenCount: GLint = -1
    let e = CGLChoosePixelFormat(attrs, &pf, &virtualScreenCount)
    if e.value != kCGLNoError.value {
      println("CGL error creating pixel format (will fall back to default): \(e)")
      return super.copyCGLPixelFormatForDisplayMask(mask)
    }
    describeFormat(pf, virtualScreen: 0)
    return pf
  }
  
  override func releaseCGLPixelFormat(pf: CGLPixelFormatObj) {
    println(__FUNCTION__)
    super.releaseCGLPixelFormat(pf)
  }
  
  override func copyCGLContextForPixelFormat(pixelFormat: CGLPixelFormatObj) -> CGLContextObj {
    return super.copyCGLContextForPixelFormat(pixelFormat)
  }

  override func releaseCGLContext(ctx: CGLContextObj) {
    println(__FUNCTION__)
    super.releaseCGLContext(ctx)
  }
  
  override func canDrawInCGLContext(ctx: CGLContextObj, pixelFormat: CGLPixelFormatObj, forLayerTime layerTime: Time,
    displayTime: UnsafePointer<CVTimeStamp>) -> Bool {
      return true
  }
  
  override func drawInCGLContext(ctx: CGLContextObj, pixelFormat: CGLPixelFormatObj, forLayerTime layerTime: Time,
    displayTime: UnsafePointer<CVTimeStamp>) {
      assert(CGLGetCurrentContext() == ctx)
      if needsInitialLayerTime {
        needsInitialLayerTime = false
        initialLayerTime = layerTime
        prevLayerTime = layerTime
      }
      handleEvent(.Tick(GLTick(time: layerTime)))
      render(F32(contentsScale), bounds.size.vs, layerTime)
      prevLayerTime = layerTime
      // according to the header comments, we should call super to flush correctly.
      super.drawInCGLContext(ctx, pixelFormat: pixelFormat, forLayerTime: layerTime, displayTime:displayTime)
  }
  
  // GLLayer.
  
  func describeFormat(format: CGLPixelFormatObj, virtualScreen: GLint) {
    println("pixel format: \(format)");
    func desc(attr: CGLPixelFormatAttribute, name: String) {
      var val: GLint = 0
      let e = CGLDescribePixelFormat(format, virtualScreen, attr, &val)
      if e.value != kCGLNoError.value {
        println("  \(name): ERROR: \(e)")
      } else if val != 0 {
        println("  \(name): \(val)")
      }
    }
    desc(kCGLPFAAccelerated, "Accelerated")
    desc(kCGLPFAAcceleratedCompute, "AcceleratedCompute")
    desc(kCGLPFAAllRenderers, "AllRenderers")
    desc(kCGLPFAAllowOfflineRenderers, "AllowOfflineRenderers")
    desc(kCGLPFAAlphaSize, "AlphaSize")
    desc(kCGLPFABackingStore, "BackingStore")
    desc(kCGLPFAClosestPolicy, "ClosestPolicy")
    desc(kCGLPFAColorFloat, "ColorFloat")
    desc(kCGLPFAColorSize, "ColorSize")
    desc(kCGLPFADepthSize, "DepthSize")
    desc(kCGLPFADisplayMask, "DisplayMask")
    desc(kCGLPFADoubleBuffer, "DoubleBuffer")
    desc(kCGLPFAMaximumPolicy, "MaximumPolicy")
    desc(kCGLPFAMinimumPolicy, "MinimumPolicy")
    desc(kCGLPFAMultisample, "Multisample")
    desc(kCGLPFANoRecovery, "NoRecovery")
    desc(kCGLPFAOpenGLProfile, "OpenGLProfile")
    desc(kCGLPFARendererID, "RendererID")
    desc(kCGLPFASampleAlpha, "SampleAlpha")
    desc(kCGLPFASampleBuffers, "SampleBuffers")
    desc(kCGLPFASamples, "Samples")
    desc(kCGLPFAStencilSize, "StencilSize")
    desc(kCGLPFAStereo, "Stereo")
    desc(kCGLPFASupersample, "Supersample")
    desc(kCGLPFAVirtualScreenCount, "VirtualScreenCount")
    println()
  }

  #else // iOS
  
  // TODO: implement asynchronous with an internal CADisplayLink.
  
  #endif
}
