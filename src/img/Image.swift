// Copyright 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


class Image {

  let fmt: PixFmt
  let w: Int
  let h: Int
  let data: UnsafeMutablePointer<Void>
  let meta: NSMutableDictionary?

  deinit {
    free(data)
  }
  
  init(fmt: PixFmt, w: Int, h: Int, data: UnsafeMutablePointer<Void>, meta: NSMutableDictionary?) {
    self.fmt = fmt
    self.w = w
    self.h = h
    self.data = data
    self.meta = meta
  }
  
  static func fromPngFile(
    file: CFile,
    name: String,
    gammaCorrect: Bool,
    displayExponent: F64) -> Result<Image> {
      var w: Int = 0
      var h: Int = 0
      var error: NSError? = nil
      var _hasRGB = ObjCBool(true) // will be overwritten.
      var _hasAlpha = ObjCBool(true) // " "
      var _is16Bit = ObjCBool(false) // " "
      let data = imgDataFromPngFile(file, name, false, gammaCorrect, displayExponent, &w, &h, &_hasRGB, &_hasAlpha, &_is16Bit, &error)
      if (error != nil) {
        print("Image error: \(error)")
        return .Fail
      }
      let fmt = PixFmt(hasRGB: Bool(_hasRGB), hasAlpha: Bool(_hasAlpha), is16Bit: Bool(_is16Bit))
      return .Ok(Image(fmt: fmt, w: w, h: h, data: data, meta: nil))
  }
  
  static func fromPngFile(
    file: CFile,
    name: String,
    gammaCorrect: Bool,
    displayExponent: F64,
    hasRGB: Bool,
    hasAlpha: Bool,
    is16Bit: Bool) -> Result<Image> {
      var w: Int = 0
      var h: Int = 0
      var error: NSError? = nil
      var _hasRGB = ObjCBool(hasRGB)
      var _hasAlpha = ObjCBool(hasAlpha)
      var _is16Bit = ObjCBool(is16Bit)
      let data = imgDataFromPngFile(file, name, true, gammaCorrect, displayExponent, &w, &h, &_hasRGB, &_hasAlpha, &_is16Bit, &error)
      assert(hasRGB == Bool(_hasRGB))
      assert(hasAlpha == Bool(_hasAlpha))
      assert(is16Bit == Bool(_is16Bit))
      if (error != nil) {
        print("Image error: \(error)")
        return .Fail
      }
      let fmt = PixFmt(hasRGB: hasRGB, hasAlpha: hasAlpha, is16Bit: is16Bit)
      return .Ok(Image(fmt: fmt, w: w, h: h, data: data, meta: nil))
  }
  
}
