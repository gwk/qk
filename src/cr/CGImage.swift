// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGImage {

  enum Error: ErrorType {
    case JPEG(path: String)
    case Path(path: String)
    case PathExtension(path: String)
    case PNG(path: String)
  }

  static let missing = try! CGImageRef.with(path: pathForResource("missing.png")) // TODO: move into resource bundle or render.

  class func with(path path: String, shouldInterpolate: Bool = false, intent: CGColorRenderingIntent = .RenderingIntentDefault) throws -> CGImage {
    guard let provider = CGDataProviderCreateWithFilename(path) else {
      throw Error.Path(path: path)
    }
    switch path.pathExt {
    case ".jpg": if let i = CGImageCreateWithJPEGDataProvider(provider, nil, shouldInterpolate, intent) {
      return i
    } else { throw Error.JPEG(path: path) }
    case ".png": if let i = CGImageCreateWithPNGDataProvider(provider, nil, shouldInterpolate, intent) {
      return i
    } else { throw Error.PNG(path: path) }
    default: throw Error.PathExtension(path: path)
    }
  }

  var w: Int { return CGImageGetWidth(self) }
  var h: Int { return CGImageGetHeight(self) }
  var bitsPerComponent: Int { return CGImageGetBitsPerComponent(self) }
  var colorSpace: CGColorSpace? { return CGImageGetColorSpace(self) }
  var bitmapInfo: CGBitmapInfo { return CGImageGetBitmapInfo(self) }

  func makeBitmapContext() -> CGContext {
    return CGBitmapContextCreate(nil, w, h, bitsPerComponent, 0, colorSpace, bitmapInfo.rawValue)!
  }

  func flipH() -> CGImage {
    let ctx = CGBitmapContextCreate(nil, w, h, bitsPerComponent, 0, colorSpace, bitmapInfo.rawValue)!
    ctx.flipHCTM()
    ctx.drawImage(self)
    return ctx.createImage()
  }
}
