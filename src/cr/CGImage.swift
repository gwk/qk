// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation
import CoreGraphics


extension CGImage {

  enum Error: ErrorType {
    case JPEG(path: String)
    case Path(path: String)
    case PathExtension(path: String)
    case PNG(path: String)
  }

  static let missing = try! CGImageRef.with(path: pathForResource("missing.png")) // TODO: move into resource bundle or render.

  class func with(path path: String, shouldInterpolate: Bool = true, intent: CGColorRenderingIntent = .RenderingIntentDefault) throws -> CGImage {
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

  class func with<T: PixelType>(bufferPointer bufferPointer: UnsafeBufferPointer<T>, size: V2I, colorSpace: CGColorSpace,
    bitmapInfo: CGBitmapInfo, shouldInterpolate: Bool, intent: CGColorRenderingIntent) -> CGImage {
      typealias Scalar = T.Scalar
      let bytesPerComponent = sizeof(Scalar) // BUG: xc7b4 does not understand T.Scalar; typealias above works around.
      let bytesPerPixel = sizeof(T)
      let bitsPerComponent = 8 * bytesPerComponent
      let bitsPerPixel = 8 * bytesPerPixel
      let bytesPerRow = bytesPerPixel * size.x
      let data = NSData(bytes: bufferPointer.baseAddress, length: bufferPointer.count * bytesPerPixel)
      let provider = CGDataProviderCreateWithCFData(data)
      let decodeArray: UnsafePointer<Flt> = nil
      return CGImageCreate(size.x, size.y,
        bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, provider, decodeArray, shouldInterpolate, intent)!
  }

  class func with<T: PixelType>(areaBuffer areaBuffer: AreaBuffer<T>, shouldInterpolate: Bool = true,
    intent: CGColorRenderingIntent = .RenderingIntentDefault) -> CGImage {
      return areaBuffer.withUnsafeBufferPointer() {
        typealias Scalar = T.Scalar
        let isRGB = T.numComponents >= 3
        let isFloat = (sizeof(Scalar) == 4)
        let hasAlpha = (T.numComponents % 2 == 0)
        let colorSpace = isRGB ? CGColorSpaceCreateDeviceRGB()! : CGColorSpaceCreateDeviceGray()!
        let byteOrder: CGBitmapInfo
        switch sizeof(Scalar) {
        case 1: byteOrder = .ByteOrderDefault
        case 2: byteOrder = .ByteOrder16Little
        case 4: byteOrder = .ByteOrder32Little
        default: fatalError("unsupported PixelType.Scalar: \(T.self)")
        }
        var bitmapInfo: CGBitmapInfo = byteOrder
        if isFloat {
          bitmapInfo.insert(.FloatComponents)
        }
        if hasAlpha {
          bitmapInfo.insert(CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)) // TODO: explore if non-premultiplied is supported.
        }
        return with(bufferPointer: $0, size: areaBuffer.size, colorSpace: colorSpace, bitmapInfo: bitmapInfo, shouldInterpolate: shouldInterpolate, intent: intent)
      }
  }


  var w: Int { return CGImageGetWidth(self) }
  var h: Int { return CGImageGetHeight(self) }
  var bounds: CGRect { return CGRect(Flt(w), Flt(h)) }
  
  var bitsPerComponent: Int { return CGImageGetBitsPerComponent(self) }
  var colorSpace: CGColorSpace? { return CGImageGetColorSpace(self) }
  var bitmapInfo: CGBitmapInfo { return CGImageGetBitmapInfo(self) }

  func makeBitmapContext() -> CGContext {
    return CGBitmapContextCreate(nil, w, h, bitsPerComponent, 0, colorSpace, bitmapInfo.rawValue)!
  }

  func flipH() -> CGImage {
    let ctx = CGBitmapContextCreate(nil, w, h, bitsPerComponent, 0, colorSpace, bitmapInfo.rawValue)!
    ctx.flipCTMHori()
    ctx.drawImage(self)
    return ctx.createImage()
  }
}
