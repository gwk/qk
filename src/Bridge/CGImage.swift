// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation
import CoreGraphics


extension CGImage {

  enum Error: ErrorProtocol {
    case jpeg(path: String)
    case path(path: String)
    case pathExtension(path: String)
    case png(path: String)
  }

  static let missing: CGImage = CGImage.with(
    areaBuffer: AreaBuffer<U8>(size: V2I(8, 8), seq: [
      0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40,
      0x40, 0x80, 0xff, 0xff, 0xff, 0xff, 0x80, 0x40,
      0x40, 0xff, 0xff, 0x80, 0x80, 0xff, 0xff, 0x40,
      0x40, 0xff, 0x80, 0x80, 0x80, 0xff, 0xff, 0x40,
      0x40, 0x80, 0x80, 0x80, 0xff, 0xff, 0x80, 0x40,
      0x40, 0x80, 0x80, 0xff, 0xff, 0x80, 0x80, 0x40,
      0x40, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x40,
      0x40, 0x40, 0x40, 0xff, 0xff, 0x40, 0x40, 0x40,
      ]),
    shouldInterpolate: false)

  class func from(path: String,
             shouldInterpolate: Bool = true,
             intent: CGColorRenderingIntent = .defaultIntent) throws -> CGImage {
    guard let provider = CGDataProvider(filename: path) else {
      throw Error.path(path: path)
    }
    switch path.pathExt {
    case ".jpg": if let i = CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: shouldInterpolate, intent: intent) {
      return i
    } else { throw Error.jpeg(path: path) }
    case ".png": if let i = CGImage(pngDataProviderSource: provider, decode: nil, shouldInterpolate: shouldInterpolate, intent: intent) {
      return i
    } else { throw Error.png(path: path) }
    default: throw Error.pathExtension(path: path)
    }
  }

  class func with<T: PixelType>(bufferPointer: UnsafeBufferPointer<T>, size: V2I, colorSpace: CGColorSpace,
    bitmapInfo: CGBitmapInfo, shouldInterpolate: Bool, intent: CGColorRenderingIntent) -> CGImage {
      typealias Scalar = T.Scalar
      let bytesPerComponent = sizeof(Scalar) // BUG: xc7b4 does not understand T.Scalar; typealias above works around.
      let bytesPerPixel = sizeof(T)
      let bitsPerComponent = 8 * bytesPerComponent
      let bitsPerPixel = 8 * bytesPerPixel
      let bytesPerRow = bytesPerPixel * size.x
      let data = Data(bytes: UnsafePointer<UInt8>(bufferPointer.baseAddress!), count: bufferPointer.count * bytesPerPixel)
      let provider = CGDataProvider(data: data)
      let decodeArray: UnsafePointer<Flt>? = nil
      return CGImage(width: size.x, height: size.y,
        bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, provider: provider!, decode: decodeArray, shouldInterpolate: shouldInterpolate, intent: intent)!
  }

  class func with<T: PixelType>(areaBuffer: AreaBuffer<T>, shouldInterpolate: Bool = true,
    intent: CGColorRenderingIntent = .defaultIntent) -> CGImage {
      return areaBuffer.withUnsafeBufferPointer() {
        typealias Scalar = T.Scalar
        let isRGB = T.numComponents >= 3
        let isFloat = (sizeof(Scalar) == 4)
        let hasAlpha = (T.numComponents % 2 == 0)
        let colorSpace = isRGB ? CGColorSpaceCreateDeviceRGB() : CGColorSpaceCreateDeviceGray()
        let byteOrder: CGBitmapInfo
        switch sizeof(Scalar) {
        case 1: byteOrder = CGBitmapInfo()
        case 2: byteOrder = .byteOrder16Little
        case 4: byteOrder = .byteOrder32Little
        default: fatalError("unsupported PixelType.Scalar: \(T.self)")
        }
        var bitmapInfo: CGBitmapInfo = byteOrder
        if isFloat {
          bitmapInfo.insert(.floatComponents)
        }
        if hasAlpha {
          bitmapInfo.insert(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)) // TODO: explore if non-premultiplied is supported.
        }
        return with(bufferPointer: $0, size: areaBuffer.size, colorSpace: colorSpace, bitmapInfo: bitmapInfo, shouldInterpolate: shouldInterpolate, intent: intent)
      }
  }


  var w: Int { return self.width }
  var h: Int { return self.height }
  var bounds: CGRect { return CGRect(Flt(w), Flt(h)) }
  
  var bitsPerComponent: Int { return self.bitsPerComponent }
  var colorSpace: CGColorSpace? { return self.colorSpace }
  var bitmapInfo: CGBitmapInfo { return self.bitmapInfo }

  func makeBitmapContext() -> CGContext {
    return CGContext(data: nil, width: w, height: h, bitsPerComponent: bitsPerComponent, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)!
  }

  func flipH() -> CGImage {
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: bitsPerComponent, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)!
    ctx.flipCTMHori()
    ctx.drawImage(self)
    return ctx.createImage()
  }
}
