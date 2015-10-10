// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


extension CGImage {

  enum Error: ErrorType {
    case JPEG(path: String)
    case Path(path: String)
    case PathExtension(path: String)
    case PNG(path: String)
  }

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
}
