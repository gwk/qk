// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import QuartzCore

#if os(OSX)
  typealias CRGLLayer = CAOpenGLLayer
  #else
  typealias CRGLLayer = CAEAGLLayer
#endif


typealias GLRenderFn = (contentsScale: F32, size: V2S, time: Time) -> ()
typealias GLEventFn = (GLEvent) -> ()

  
class GLLayer: CRGLLayer {

  required init?(coder: NSCoder) { fatalError() }
  
  override init() { super.init() } // layer gets instantiated for us on iOS, so we must defer initialization to setup().

  var drawableSize = V2S()
  var needsInitialLayerTime = true
  var initialLayerTime: Time = 0
  var prevLayerTime: Time = 0
  
  var pixFmt: PixFmt = .None {
    willSet { assert(pixFmt == .None, "GLLayer: altering the pixFmt is not yet supported") }
  }
  
  var render: GLRenderFn = { (contentsScale, size, time) in () } {
    didSet {}
  }
  
  var handleEvent: GLEventFn = { (event) in () }
  
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
      check(EAGLContext.setCurrentContext(context)) // in case host does not support ES2.
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
    if e.rawValue != kCGLNoError.rawValue {
      print("CGL error creating pixel format (will fall back to default): \(e)")
      return super.copyCGLPixelFormatForDisplayMask(mask)
    }
    //describeFormat(pf, virtualScreen: 0)
    return pf
  }
  
  override func releaseCGLPixelFormat(pf: CGLPixelFormatObj) {
    print(#function)
    super.releaseCGLPixelFormat(pf)
  }
  
  override func copyCGLContextForPixelFormat(pixelFormat: CGLPixelFormatObj) -> CGLContextObj {
    return super.copyCGLContextForPixelFormat(pixelFormat)
  }

  override func releaseCGLContext(ctx: CGLContextObj) {
    print(#function)
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
      render(contentsScale: F32(contentsScale), size: V2S(bounds.size), time: layerTime)
      prevLayerTime = layerTime
      // according to the header comments, we should call super to flush correctly.
      super.drawInCGLContext(ctx, pixelFormat: pixelFormat, forLayerTime: layerTime, displayTime:displayTime)
  }
  
  // GLLayer.
  
  func describeFormat(format: CGLPixelFormatObj, virtualScreen: GLint) {
    print("pixel format: \(format)");
    func desc(attr: CGLPixelFormatAttribute, name: String) {
      var val: GLint = 0
      let e = CGLDescribePixelFormat(format, virtualScreen, attr, &val)
      if e.rawValue != kCGLNoError.rawValue {
        print("  \(name): ERROR: \(e)")
      } else if val != 0 {
        print("  \(name): \(val)")
      }
    }
    desc(kCGLPFAAccelerated, name: "Accelerated")
    desc(kCGLPFAAcceleratedCompute, name: "AcceleratedCompute")
    desc(kCGLPFAAllRenderers, name: "AllRenderers")
    desc(kCGLPFAAllowOfflineRenderers, name: "AllowOfflineRenderers")
    desc(kCGLPFAAlphaSize, name: "AlphaSize")
    desc(kCGLPFABackingStore, name: "BackingStore")
    desc(kCGLPFAClosestPolicy, name: "ClosestPolicy")
    desc(kCGLPFAColorFloat, name: "ColorFloat")
    desc(kCGLPFAColorSize, name: "ColorSize")
    desc(kCGLPFADepthSize, name: "DepthSize")
    desc(kCGLPFADisplayMask, name: "DisplayMask")
    desc(kCGLPFADoubleBuffer, name: "DoubleBuffer")
    desc(kCGLPFAMaximumPolicy, name: "MaximumPolicy")
    desc(kCGLPFAMinimumPolicy, name: "MinimumPolicy")
    desc(kCGLPFAMultisample, name: "Multisample")
    desc(kCGLPFANoRecovery, name: "NoRecovery")
    desc(kCGLPFAOpenGLProfile, name: "OpenGLProfile")
    desc(kCGLPFARendererID, name: "RendererID")
    desc(kCGLPFASampleAlpha, name: "SampleAlpha")
    desc(kCGLPFASampleBuffers, name: "SampleBuffers")
    desc(kCGLPFASamples, name: "Samples")
    desc(kCGLPFAStencilSize, name: "StencilSize")
    desc(kCGLPFASupersample, name: "Supersample")
    desc(kCGLPFAVirtualScreenCount, name: "VirtualScreenCount")
    print("")
  }

  #else // iOS
  
  // TODO: implement asynchronous with an internal CADisplayLink.
  
  #endif
}
