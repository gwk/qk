// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import CoreGraphics


/* From Quartz 2D Programming Guide: Graphics Contexts
 ColorSpace, Bits per pixel, Bytes per component, Flags
 Null -   8 bpp,  8 bpc, kCGImageAlphaOnly - Mac OS X, iOS
 Gray -   8 bpp,  8 bpc, kCGImageAlphaNone - Mac OS X, iOS
 Gray -   8 bpp,  8 bpc, kCGImageAlphaOnly - Mac OS X, iOS
 Gray -  16 bpp, 16 bpc, kCGImageAlphaNone - Mac OS X
 Gray -  32 bpp, 32 bpc, kCGImageAlphaNone|kCGBitmapFloatComponents - Mac OS X
 RGB  -  16 bpp,  5 bpc, kCGImageAlphaNoneSkipFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaNoneSkipFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaNoneSkipLast - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaPremultipliedFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaPremultipliedLast - Mac OS X, iOS
 RGB  -  64 bpp, 16 bpc, kCGImageAlphaPremultipliedLast - Mac OS X
 RGB  -  64 bpp, 16 bpc, kCGImageAlphaNoneSkipLast - Mac OS X
 RGB  - 128 bpp, 32 bpc, kCGImageAlphaNoneSkipLast|kCGBitmapFloatComponents - Mac OS X
 RGB  - 128 bpp, 32 bpc, kCGImageAlphaPremultipliedLast|kCGBitmapFloatComponents - Mac OS X
 CMYK -  32 bpp,  8 bpc, kCGImageAlphaNone - Mac OS X
 CMYK -  64 bpp, 16 bpc, kCGImageAlphaNone - Mac OS X
 CMYK - 128 bpp, 32 bpc, kCGImageAlphaNone|kCGBitmapFloatComponents - Mac OS X
 */

let PixFmtBitU8: U32  = 1 << 0
let PixFmtBitU16: U32 = 1 << 1
let PixFmtBitF32: U32 = 1 << 2
let PixFmtBitA: U32   = 1 << 3 // alpha.
let PixFmtBitX: U32   = 1 << 4 // indicates skip fourth channel.
let PixFmtBitL: U32   = 1 << 5 // luminance (grayscale).
let PixFmtBitRGB: U32 = 1 << 6 // rgb.

// OpenGL flags.
let PixFmtBitD16: U32 = 1 << 7 // 16 bit depth buffer.
let PixFmtBitD24: U32 = 1 << 8 // 24 bit depth buffer.
let PixFmtBitD32: U32 = 1 << 9
// multisampling sizes of 2, 4, and 8 are supported on 2012 retina MBP, OSX 10.10.
let PixFmtBitM2: U32 = 1 << 10 // 2 multisamples.
let PixFmtBitM4: U32 = 1 << 11 // 4 multisamples.
let PixFmtBitM8: U32 = 1 << 12 // 8 multisamples.

enum PixFmt: U32, Printable {
  case None = 0
  case AU8 = 0x9 // PixFmtBitA|PixFmtBitU8
  case AU8M2 = 0x409 // PixFmtBitA|PixFmtBitU8|PixFmtBitM2
  case AU8M4 = 0x809 // PixFmtBitA|PixFmtBitU8|PixFmtBitM4
  case AU8M8 = 0x1009 // PixFmtBitA|PixFmtBitU8|PixFmtBitM8
  case AU8D16 = 0x89 // PixFmtBitA|PixFmtBitU8|PixFmtBitD16
  case AU8D16M2 = 0x489 // PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM2
  case AU8D16M4 = 0x889 // PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM4
  case AU8D16M8 = 0x1089 // PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM8
  case AU8D24 = 0x109 // PixFmtBitA|PixFmtBitU8|PixFmtBitD24
  case AU8D24M2 = 0x509 // PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM2
  case AU8D24M4 = 0x909 // PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM4
  case AU8D24M8 = 0x1109 // PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM8
  case AU8D32 = 0x209 // PixFmtBitA|PixFmtBitU8|PixFmtBitD32
  case AU8D32M2 = 0x609 // PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM2
  case AU8D32M4 = 0xa09 // PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM4
  case AU8D32M8 = 0x1209 // PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM8
  case AU16 = 0xa // PixFmtBitA|PixFmtBitU16
  case AU16M2 = 0x40a // PixFmtBitA|PixFmtBitU16|PixFmtBitM2
  case AU16M4 = 0x80a // PixFmtBitA|PixFmtBitU16|PixFmtBitM4
  case AU16M8 = 0x100a // PixFmtBitA|PixFmtBitU16|PixFmtBitM8
  case AU16D16 = 0x8a // PixFmtBitA|PixFmtBitU16|PixFmtBitD16
  case AU16D16M2 = 0x48a // PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM2
  case AU16D16M4 = 0x88a // PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM4
  case AU16D16M8 = 0x108a // PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM8
  case AU16D24 = 0x10a // PixFmtBitA|PixFmtBitU16|PixFmtBitD24
  case AU16D24M2 = 0x50a // PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM2
  case AU16D24M4 = 0x90a // PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM4
  case AU16D24M8 = 0x110a // PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM8
  case AU16D32 = 0x20a // PixFmtBitA|PixFmtBitU16|PixFmtBitD32
  case AU16D32M2 = 0x60a // PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM2
  case AU16D32M4 = 0xa0a // PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM4
  case AU16D32M8 = 0x120a // PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM8
  case AF32 = 0xc // PixFmtBitA|PixFmtBitF32
  case AF32M2 = 0x40c // PixFmtBitA|PixFmtBitF32|PixFmtBitM2
  case AF32M4 = 0x80c // PixFmtBitA|PixFmtBitF32|PixFmtBitM4
  case AF32M8 = 0x100c // PixFmtBitA|PixFmtBitF32|PixFmtBitM8
  case AF32D16 = 0x8c // PixFmtBitA|PixFmtBitF32|PixFmtBitD16
  case AF32D16M2 = 0x48c // PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM2
  case AF32D16M4 = 0x88c // PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM4
  case AF32D16M8 = 0x108c // PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM8
  case AF32D24 = 0x10c // PixFmtBitA|PixFmtBitF32|PixFmtBitD24
  case AF32D24M2 = 0x50c // PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM2
  case AF32D24M4 = 0x90c // PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM4
  case AF32D24M8 = 0x110c // PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM8
  case AF32D32 = 0x20c // PixFmtBitA|PixFmtBitF32|PixFmtBitD32
  case AF32D32M2 = 0x60c // PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM2
  case AF32D32M4 = 0xa0c // PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM4
  case AF32D32M8 = 0x120c // PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM8
  case LU8 = 0x21 // PixFmtBitL|PixFmtBitU8
  case LU8M2 = 0x421 // PixFmtBitL|PixFmtBitU8|PixFmtBitM2
  case LU8M4 = 0x821 // PixFmtBitL|PixFmtBitU8|PixFmtBitM4
  case LU8M8 = 0x1021 // PixFmtBitL|PixFmtBitU8|PixFmtBitM8
  case LU8D16 = 0xa1 // PixFmtBitL|PixFmtBitU8|PixFmtBitD16
  case LU8D16M2 = 0x4a1 // PixFmtBitL|PixFmtBitU8|PixFmtBitD16|PixFmtBitM2
  case LU8D16M4 = 0x8a1 // PixFmtBitL|PixFmtBitU8|PixFmtBitD16|PixFmtBitM4
  case LU8D16M8 = 0x10a1 // PixFmtBitL|PixFmtBitU8|PixFmtBitD16|PixFmtBitM8
  case LU8D24 = 0x121 // PixFmtBitL|PixFmtBitU8|PixFmtBitD24
  case LU8D24M2 = 0x521 // PixFmtBitL|PixFmtBitU8|PixFmtBitD24|PixFmtBitM2
  case LU8D24M4 = 0x921 // PixFmtBitL|PixFmtBitU8|PixFmtBitD24|PixFmtBitM4
  case LU8D24M8 = 0x1121 // PixFmtBitL|PixFmtBitU8|PixFmtBitD24|PixFmtBitM8
  case LU8D32 = 0x221 // PixFmtBitL|PixFmtBitU8|PixFmtBitD32
  case LU8D32M2 = 0x621 // PixFmtBitL|PixFmtBitU8|PixFmtBitD32|PixFmtBitM2
  case LU8D32M4 = 0xa21 // PixFmtBitL|PixFmtBitU8|PixFmtBitD32|PixFmtBitM4
  case LU8D32M8 = 0x1221 // PixFmtBitL|PixFmtBitU8|PixFmtBitD32|PixFmtBitM8
  case LU16 = 0x22 // PixFmtBitL|PixFmtBitU16
  case LU16M2 = 0x422 // PixFmtBitL|PixFmtBitU16|PixFmtBitM2
  case LU16M4 = 0x822 // PixFmtBitL|PixFmtBitU16|PixFmtBitM4
  case LU16M8 = 0x1022 // PixFmtBitL|PixFmtBitU16|PixFmtBitM8
  case LU16D16 = 0xa2 // PixFmtBitL|PixFmtBitU16|PixFmtBitD16
  case LU16D16M2 = 0x4a2 // PixFmtBitL|PixFmtBitU16|PixFmtBitD16|PixFmtBitM2
  case LU16D16M4 = 0x8a2 // PixFmtBitL|PixFmtBitU16|PixFmtBitD16|PixFmtBitM4
  case LU16D16M8 = 0x10a2 // PixFmtBitL|PixFmtBitU16|PixFmtBitD16|PixFmtBitM8
  case LU16D24 = 0x122 // PixFmtBitL|PixFmtBitU16|PixFmtBitD24
  case LU16D24M2 = 0x522 // PixFmtBitL|PixFmtBitU16|PixFmtBitD24|PixFmtBitM2
  case LU16D24M4 = 0x922 // PixFmtBitL|PixFmtBitU16|PixFmtBitD24|PixFmtBitM4
  case LU16D24M8 = 0x1122 // PixFmtBitL|PixFmtBitU16|PixFmtBitD24|PixFmtBitM8
  case LU16D32 = 0x222 // PixFmtBitL|PixFmtBitU16|PixFmtBitD32
  case LU16D32M2 = 0x622 // PixFmtBitL|PixFmtBitU16|PixFmtBitD32|PixFmtBitM2
  case LU16D32M4 = 0xa22 // PixFmtBitL|PixFmtBitU16|PixFmtBitD32|PixFmtBitM4
  case LU16D32M8 = 0x1222 // PixFmtBitL|PixFmtBitU16|PixFmtBitD32|PixFmtBitM8
  case LF32 = 0x24 // PixFmtBitL|PixFmtBitF32
  case LF32M2 = 0x424 // PixFmtBitL|PixFmtBitF32|PixFmtBitM2
  case LF32M4 = 0x824 // PixFmtBitL|PixFmtBitF32|PixFmtBitM4
  case LF32M8 = 0x1024 // PixFmtBitL|PixFmtBitF32|PixFmtBitM8
  case LF32D16 = 0xa4 // PixFmtBitL|PixFmtBitF32|PixFmtBitD16
  case LF32D16M2 = 0x4a4 // PixFmtBitL|PixFmtBitF32|PixFmtBitD16|PixFmtBitM2
  case LF32D16M4 = 0x8a4 // PixFmtBitL|PixFmtBitF32|PixFmtBitD16|PixFmtBitM4
  case LF32D16M8 = 0x10a4 // PixFmtBitL|PixFmtBitF32|PixFmtBitD16|PixFmtBitM8
  case LF32D24 = 0x124 // PixFmtBitL|PixFmtBitF32|PixFmtBitD24
  case LF32D24M2 = 0x524 // PixFmtBitL|PixFmtBitF32|PixFmtBitD24|PixFmtBitM2
  case LF32D24M4 = 0x924 // PixFmtBitL|PixFmtBitF32|PixFmtBitD24|PixFmtBitM4
  case LF32D24M8 = 0x1124 // PixFmtBitL|PixFmtBitF32|PixFmtBitD24|PixFmtBitM8
  case LF32D32 = 0x224 // PixFmtBitL|PixFmtBitF32|PixFmtBitD32
  case LF32D32M2 = 0x624 // PixFmtBitL|PixFmtBitF32|PixFmtBitD32|PixFmtBitM2
  case LF32D32M4 = 0xa24 // PixFmtBitL|PixFmtBitF32|PixFmtBitD32|PixFmtBitM4
  case LF32D32M8 = 0x1224 // PixFmtBitL|PixFmtBitF32|PixFmtBitD32|PixFmtBitM8
  case LAU8 = 0x29 // PixFmtBitL|PixFmtBitA|PixFmtBitU8
  case LAU8M2 = 0x429 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitM2
  case LAU8M4 = 0x829 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitM4
  case LAU8M8 = 0x1029 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitM8
  case LAU8D16 = 0xa9 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD16
  case LAU8D16M2 = 0x4a9 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM2
  case LAU8D16M4 = 0x8a9 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM4
  case LAU8D16M8 = 0x10a9 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM8
  case LAU8D24 = 0x129 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD24
  case LAU8D24M2 = 0x529 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM2
  case LAU8D24M4 = 0x929 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM4
  case LAU8D24M8 = 0x1129 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM8
  case LAU8D32 = 0x229 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD32
  case LAU8D32M2 = 0x629 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM2
  case LAU8D32M4 = 0xa29 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM4
  case LAU8D32M8 = 0x1229 // PixFmtBitL|PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM8
  case LAU16 = 0x2a // PixFmtBitL|PixFmtBitA|PixFmtBitU16
  case LAU16M2 = 0x42a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitM2
  case LAU16M4 = 0x82a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitM4
  case LAU16M8 = 0x102a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitM8
  case LAU16D16 = 0xaa // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD16
  case LAU16D16M2 = 0x4aa // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM2
  case LAU16D16M4 = 0x8aa // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM4
  case LAU16D16M8 = 0x10aa // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM8
  case LAU16D24 = 0x12a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD24
  case LAU16D24M2 = 0x52a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM2
  case LAU16D24M4 = 0x92a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM4
  case LAU16D24M8 = 0x112a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM8
  case LAU16D32 = 0x22a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD32
  case LAU16D32M2 = 0x62a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM2
  case LAU16D32M4 = 0xa2a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM4
  case LAU16D32M8 = 0x122a // PixFmtBitL|PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM8
  case LAF32 = 0x2c // PixFmtBitL|PixFmtBitA|PixFmtBitF32
  case LAF32M2 = 0x42c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitM2
  case LAF32M4 = 0x82c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitM4
  case LAF32M8 = 0x102c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitM8
  case LAF32D16 = 0xac // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD16
  case LAF32D16M2 = 0x4ac // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM2
  case LAF32D16M4 = 0x8ac // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM4
  case LAF32D16M8 = 0x10ac // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM8
  case LAF32D24 = 0x12c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD24
  case LAF32D24M2 = 0x52c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM2
  case LAF32D24M4 = 0x92c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM4
  case LAF32D24M8 = 0x112c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM8
  case LAF32D32 = 0x22c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD32
  case LAF32D32M2 = 0x62c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM2
  case LAF32D32M4 = 0xa2c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM4
  case LAF32D32M8 = 0x122c // PixFmtBitL|PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM8
  case RGBU8 = 0x41 // PixFmtBitRGB|PixFmtBitU8
  case RGBU8M2 = 0x441 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitM2
  case RGBU8M4 = 0x841 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitM4
  case RGBU8M8 = 0x1041 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitM8
  case RGBU8D16 = 0xc1 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD16
  case RGBU8D16M2 = 0x4c1 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD16|PixFmtBitM2
  case RGBU8D16M4 = 0x8c1 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD16|PixFmtBitM4
  case RGBU8D16M8 = 0x10c1 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD16|PixFmtBitM8
  case RGBU8D24 = 0x141 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD24
  case RGBU8D24M2 = 0x541 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD24|PixFmtBitM2
  case RGBU8D24M4 = 0x941 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD24|PixFmtBitM4
  case RGBU8D24M8 = 0x1141 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD24|PixFmtBitM8
  case RGBU8D32 = 0x241 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD32
  case RGBU8D32M2 = 0x641 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD32|PixFmtBitM2
  case RGBU8D32M4 = 0xa41 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD32|PixFmtBitM4
  case RGBU8D32M8 = 0x1241 // PixFmtBitRGB|PixFmtBitU8|PixFmtBitD32|PixFmtBitM8
  case RGBU16 = 0x42 // PixFmtBitRGB|PixFmtBitU16
  case RGBU16M2 = 0x442 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitM2
  case RGBU16M4 = 0x842 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitM4
  case RGBU16M8 = 0x1042 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitM8
  case RGBU16D16 = 0xc2 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD16
  case RGBU16D16M2 = 0x4c2 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD16|PixFmtBitM2
  case RGBU16D16M4 = 0x8c2 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD16|PixFmtBitM4
  case RGBU16D16M8 = 0x10c2 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD16|PixFmtBitM8
  case RGBU16D24 = 0x142 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD24
  case RGBU16D24M2 = 0x542 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD24|PixFmtBitM2
  case RGBU16D24M4 = 0x942 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD24|PixFmtBitM4
  case RGBU16D24M8 = 0x1142 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD24|PixFmtBitM8
  case RGBU16D32 = 0x242 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD32
  case RGBU16D32M2 = 0x642 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD32|PixFmtBitM2
  case RGBU16D32M4 = 0xa42 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD32|PixFmtBitM4
  case RGBU16D32M8 = 0x1242 // PixFmtBitRGB|PixFmtBitU16|PixFmtBitD32|PixFmtBitM8
  case RGBF32 = 0x44 // PixFmtBitRGB|PixFmtBitF32
  case RGBF32M2 = 0x444 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitM2
  case RGBF32M4 = 0x844 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitM4
  case RGBF32M8 = 0x1044 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitM8
  case RGBF32D16 = 0xc4 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD16
  case RGBF32D16M2 = 0x4c4 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD16|PixFmtBitM2
  case RGBF32D16M4 = 0x8c4 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD16|PixFmtBitM4
  case RGBF32D16M8 = 0x10c4 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD16|PixFmtBitM8
  case RGBF32D24 = 0x144 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD24
  case RGBF32D24M2 = 0x544 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD24|PixFmtBitM2
  case RGBF32D24M4 = 0x944 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD24|PixFmtBitM4
  case RGBF32D24M8 = 0x1144 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD24|PixFmtBitM8
  case RGBF32D32 = 0x244 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD32
  case RGBF32D32M2 = 0x644 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD32|PixFmtBitM2
  case RGBF32D32M4 = 0xa44 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD32|PixFmtBitM4
  case RGBF32D32M8 = 0x1244 // PixFmtBitRGB|PixFmtBitF32|PixFmtBitD32|PixFmtBitM8
  case RGBAU8 = 0x49 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8
  case RGBAU8M2 = 0x449 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitM2
  case RGBAU8M4 = 0x849 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitM4
  case RGBAU8M8 = 0x1049 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitM8
  case RGBAU8D16 = 0xc9 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD16
  case RGBAU8D16M2 = 0x4c9 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM2
  case RGBAU8D16M4 = 0x8c9 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM4
  case RGBAU8D16M8 = 0x10c9 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD16|PixFmtBitM8
  case RGBAU8D24 = 0x149 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD24
  case RGBAU8D24M2 = 0x549 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM2
  case RGBAU8D24M4 = 0x949 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM4
  case RGBAU8D24M8 = 0x1149 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD24|PixFmtBitM8
  case RGBAU8D32 = 0x249 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD32
  case RGBAU8D32M2 = 0x649 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM2
  case RGBAU8D32M4 = 0xa49 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM4
  case RGBAU8D32M8 = 0x1249 // PixFmtBitRGB|PixFmtBitA|PixFmtBitU8|PixFmtBitD32|PixFmtBitM8
  case RGBAU16 = 0x4a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16
  case RGBAU16M2 = 0x44a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitM2
  case RGBAU16M4 = 0x84a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitM4
  case RGBAU16M8 = 0x104a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitM8
  case RGBAU16D16 = 0xca // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD16
  case RGBAU16D16M2 = 0x4ca // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM2
  case RGBAU16D16M4 = 0x8ca // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM4
  case RGBAU16D16M8 = 0x10ca // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD16|PixFmtBitM8
  case RGBAU16D24 = 0x14a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD24
  case RGBAU16D24M2 = 0x54a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM2
  case RGBAU16D24M4 = 0x94a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM4
  case RGBAU16D24M8 = 0x114a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD24|PixFmtBitM8
  case RGBAU16D32 = 0x24a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD32
  case RGBAU16D32M2 = 0x64a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM2
  case RGBAU16D32M4 = 0xa4a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM4
  case RGBAU16D32M8 = 0x124a // PixFmtBitRGB|PixFmtBitA|PixFmtBitU16|PixFmtBitD32|PixFmtBitM8
  case RGBAF32 = 0x4c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32
  case RGBAF32M2 = 0x44c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitM2
  case RGBAF32M4 = 0x84c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitM4
  case RGBAF32M8 = 0x104c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitM8
  case RGBAF32D16 = 0xcc // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD16
  case RGBAF32D16M2 = 0x4cc // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM2
  case RGBAF32D16M4 = 0x8cc // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM4
  case RGBAF32D16M8 = 0x10cc // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD16|PixFmtBitM8
  case RGBAF32D24 = 0x14c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD24
  case RGBAF32D24M2 = 0x54c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM2
  case RGBAF32D24M4 = 0x94c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM4
  case RGBAF32D24M8 = 0x114c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD24|PixFmtBitM8
  case RGBAF32D32 = 0x24c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD32
  case RGBAF32D32M2 = 0x64c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM2
  case RGBAF32D32M4 = 0xa4c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM4
  case RGBAF32D32M8 = 0x124c // PixFmtBitRGB|PixFmtBitA|PixFmtBitF32|PixFmtBitD32|PixFmtBitM8
  case RGBXU8 = 0x51 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8
  case RGBXU8M2 = 0x451 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitM2
  case RGBXU8M4 = 0x851 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitM4
  case RGBXU8M8 = 0x1051 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitM8
  case RGBXU8D16 = 0xd1 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD16
  case RGBXU8D16M2 = 0x4d1 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD16|PixFmtBitM2
  case RGBXU8D16M4 = 0x8d1 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD16|PixFmtBitM4
  case RGBXU8D16M8 = 0x10d1 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD16|PixFmtBitM8
  case RGBXU8D24 = 0x151 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD24
  case RGBXU8D24M2 = 0x551 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD24|PixFmtBitM2
  case RGBXU8D24M4 = 0x951 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD24|PixFmtBitM4
  case RGBXU8D24M8 = 0x1151 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD24|PixFmtBitM8
  case RGBXU8D32 = 0x251 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD32
  case RGBXU8D32M2 = 0x651 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD32|PixFmtBitM2
  case RGBXU8D32M4 = 0xa51 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD32|PixFmtBitM4
  case RGBXU8D32M8 = 0x1251 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU8|PixFmtBitD32|PixFmtBitM8
  case RGBXU16 = 0x52 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16
  case RGBXU16M2 = 0x452 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitM2
  case RGBXU16M4 = 0x852 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitM4
  case RGBXU16M8 = 0x1052 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitM8
  case RGBXU16D16 = 0xd2 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD16
  case RGBXU16D16M2 = 0x4d2 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD16|PixFmtBitM2
  case RGBXU16D16M4 = 0x8d2 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD16|PixFmtBitM4
  case RGBXU16D16M8 = 0x10d2 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD16|PixFmtBitM8
  case RGBXU16D24 = 0x152 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD24
  case RGBXU16D24M2 = 0x552 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD24|PixFmtBitM2
  case RGBXU16D24M4 = 0x952 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD24|PixFmtBitM4
  case RGBXU16D24M8 = 0x1152 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD24|PixFmtBitM8
  case RGBXU16D32 = 0x252 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD32
  case RGBXU16D32M2 = 0x652 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD32|PixFmtBitM2
  case RGBXU16D32M4 = 0xa52 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD32|PixFmtBitM4
  case RGBXU16D32M8 = 0x1252 // PixFmtBitRGB|PixFmtBitX|PixFmtBitU16|PixFmtBitD32|PixFmtBitM8
  case RGBXF32 = 0x54 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32
  case RGBXF32M2 = 0x454 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitM2
  case RGBXF32M4 = 0x854 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitM4
  case RGBXF32M8 = 0x1054 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitM8
  case RGBXF32D16 = 0xd4 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD16
  case RGBXF32D16M2 = 0x4d4 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD16|PixFmtBitM2
  case RGBXF32D16M4 = 0x8d4 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD16|PixFmtBitM4
  case RGBXF32D16M8 = 0x10d4 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD16|PixFmtBitM8
  case RGBXF32D24 = 0x154 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD24
  case RGBXF32D24M2 = 0x554 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD24|PixFmtBitM2
  case RGBXF32D24M4 = 0x954 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD24|PixFmtBitM4
  case RGBXF32D24M8 = 0x1154 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD24|PixFmtBitM8
  case RGBXF32D32 = 0x254 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD32
  case RGBXF32D32M2 = 0x654 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD32|PixFmtBitM2
  case RGBXF32D32M4 = 0xa54 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD32|PixFmtBitM4
  case RGBXF32D32M8 = 0x1254 // PixFmtBitRGB|PixFmtBitX|PixFmtBitF32|PixFmtBitD32|PixFmtBitM8
  
  var description: String {
    switch self {
    case .None: return "None"
    case .AU8: return "AU8"
    case .AU8M2: return "AU8M2"
    case .AU8M4: return "AU8M4"
    case .AU8M8: return "AU8M8"
    case .AU8D16: return "AU8D16"
    case .AU8D16M2: return "AU8D16M2"
    case .AU8D16M4: return "AU8D16M4"
    case .AU8D16M8: return "AU8D16M8"
    case .AU8D24: return "AU8D24"
    case .AU8D24M2: return "AU8D24M2"
    case .AU8D24M4: return "AU8D24M4"
    case .AU8D24M8: return "AU8D24M8"
    case .AU8D32: return "AU8D32"
    case .AU8D32M2: return "AU8D32M2"
    case .AU8D32M4: return "AU8D32M4"
    case .AU8D32M8: return "AU8D32M8"
    case .AU16: return "AU16"
    case .AU16M2: return "AU16M2"
    case .AU16M4: return "AU16M4"
    case .AU16M8: return "AU16M8"
    case .AU16D16: return "AU16D16"
    case .AU16D16M2: return "AU16D16M2"
    case .AU16D16M4: return "AU16D16M4"
    case .AU16D16M8: return "AU16D16M8"
    case .AU16D24: return "AU16D24"
    case .AU16D24M2: return "AU16D24M2"
    case .AU16D24M4: return "AU16D24M4"
    case .AU16D24M8: return "AU16D24M8"
    case .AU16D32: return "AU16D32"
    case .AU16D32M2: return "AU16D32M2"
    case .AU16D32M4: return "AU16D32M4"
    case .AU16D32M8: return "AU16D32M8"
    case .AF32: return "AF32"
    case .AF32M2: return "AF32M2"
    case .AF32M4: return "AF32M4"
    case .AF32M8: return "AF32M8"
    case .AF32D16: return "AF32D16"
    case .AF32D16M2: return "AF32D16M2"
    case .AF32D16M4: return "AF32D16M4"
    case .AF32D16M8: return "AF32D16M8"
    case .AF32D24: return "AF32D24"
    case .AF32D24M2: return "AF32D24M2"
    case .AF32D24M4: return "AF32D24M4"
    case .AF32D24M8: return "AF32D24M8"
    case .AF32D32: return "AF32D32"
    case .AF32D32M2: return "AF32D32M2"
    case .AF32D32M4: return "AF32D32M4"
    case .AF32D32M8: return "AF32D32M8"
    case .LU8: return "LU8"
    case .LU8M2: return "LU8M2"
    case .LU8M4: return "LU8M4"
    case .LU8M8: return "LU8M8"
    case .LU8D16: return "LU8D16"
    case .LU8D16M2: return "LU8D16M2"
    case .LU8D16M4: return "LU8D16M4"
    case .LU8D16M8: return "LU8D16M8"
    case .LU8D24: return "LU8D24"
    case .LU8D24M2: return "LU8D24M2"
    case .LU8D24M4: return "LU8D24M4"
    case .LU8D24M8: return "LU8D24M8"
    case .LU8D32: return "LU8D32"
    case .LU8D32M2: return "LU8D32M2"
    case .LU8D32M4: return "LU8D32M4"
    case .LU8D32M8: return "LU8D32M8"
    case .LU16: return "LU16"
    case .LU16M2: return "LU16M2"
    case .LU16M4: return "LU16M4"
    case .LU16M8: return "LU16M8"
    case .LU16D16: return "LU16D16"
    case .LU16D16M2: return "LU16D16M2"
    case .LU16D16M4: return "LU16D16M4"
    case .LU16D16M8: return "LU16D16M8"
    case .LU16D24: return "LU16D24"
    case .LU16D24M2: return "LU16D24M2"
    case .LU16D24M4: return "LU16D24M4"
    case .LU16D24M8: return "LU16D24M8"
    case .LU16D32: return "LU16D32"
    case .LU16D32M2: return "LU16D32M2"
    case .LU16D32M4: return "LU16D32M4"
    case .LU16D32M8: return "LU16D32M8"
    case .LF32: return "LF32"
    case .LF32M2: return "LF32M2"
    case .LF32M4: return "LF32M4"
    case .LF32M8: return "LF32M8"
    case .LF32D16: return "LF32D16"
    case .LF32D16M2: return "LF32D16M2"
    case .LF32D16M4: return "LF32D16M4"
    case .LF32D16M8: return "LF32D16M8"
    case .LF32D24: return "LF32D24"
    case .LF32D24M2: return "LF32D24M2"
    case .LF32D24M4: return "LF32D24M4"
    case .LF32D24M8: return "LF32D24M8"
    case .LF32D32: return "LF32D32"
    case .LF32D32M2: return "LF32D32M2"
    case .LF32D32M4: return "LF32D32M4"
    case .LF32D32M8: return "LF32D32M8"
    case .LAU8: return "LAU8"
    case .LAU8M2: return "LAU8M2"
    case .LAU8M4: return "LAU8M4"
    case .LAU8M8: return "LAU8M8"
    case .LAU8D16: return "LAU8D16"
    case .LAU8D16M2: return "LAU8D16M2"
    case .LAU8D16M4: return "LAU8D16M4"
    case .LAU8D16M8: return "LAU8D16M8"
    case .LAU8D24: return "LAU8D24"
    case .LAU8D24M2: return "LAU8D24M2"
    case .LAU8D24M4: return "LAU8D24M4"
    case .LAU8D24M8: return "LAU8D24M8"
    case .LAU8D32: return "LAU8D32"
    case .LAU8D32M2: return "LAU8D32M2"
    case .LAU8D32M4: return "LAU8D32M4"
    case .LAU8D32M8: return "LAU8D32M8"
    case .LAU16: return "LAU16"
    case .LAU16M2: return "LAU16M2"
    case .LAU16M4: return "LAU16M4"
    case .LAU16M8: return "LAU16M8"
    case .LAU16D16: return "LAU16D16"
    case .LAU16D16M2: return "LAU16D16M2"
    case .LAU16D16M4: return "LAU16D16M4"
    case .LAU16D16M8: return "LAU16D16M8"
    case .LAU16D24: return "LAU16D24"
    case .LAU16D24M2: return "LAU16D24M2"
    case .LAU16D24M4: return "LAU16D24M4"
    case .LAU16D24M8: return "LAU16D24M8"
    case .LAU16D32: return "LAU16D32"
    case .LAU16D32M2: return "LAU16D32M2"
    case .LAU16D32M4: return "LAU16D32M4"
    case .LAU16D32M8: return "LAU16D32M8"
    case .LAF32: return "LAF32"
    case .LAF32M2: return "LAF32M2"
    case .LAF32M4: return "LAF32M4"
    case .LAF32M8: return "LAF32M8"
    case .LAF32D16: return "LAF32D16"
    case .LAF32D16M2: return "LAF32D16M2"
    case .LAF32D16M4: return "LAF32D16M4"
    case .LAF32D16M8: return "LAF32D16M8"
    case .LAF32D24: return "LAF32D24"
    case .LAF32D24M2: return "LAF32D24M2"
    case .LAF32D24M4: return "LAF32D24M4"
    case .LAF32D24M8: return "LAF32D24M8"
    case .LAF32D32: return "LAF32D32"
    case .LAF32D32M2: return "LAF32D32M2"
    case .LAF32D32M4: return "LAF32D32M4"
    case .LAF32D32M8: return "LAF32D32M8"
    case .RGBU8: return "RGBU8"
    case .RGBU8M2: return "RGBU8M2"
    case .RGBU8M4: return "RGBU8M4"
    case .RGBU8M8: return "RGBU8M8"
    case .RGBU8D16: return "RGBU8D16"
    case .RGBU8D16M2: return "RGBU8D16M2"
    case .RGBU8D16M4: return "RGBU8D16M4"
    case .RGBU8D16M8: return "RGBU8D16M8"
    case .RGBU8D24: return "RGBU8D24"
    case .RGBU8D24M2: return "RGBU8D24M2"
    case .RGBU8D24M4: return "RGBU8D24M4"
    case .RGBU8D24M8: return "RGBU8D24M8"
    case .RGBU8D32: return "RGBU8D32"
    case .RGBU8D32M2: return "RGBU8D32M2"
    case .RGBU8D32M4: return "RGBU8D32M4"
    case .RGBU8D32M8: return "RGBU8D32M8"
    case .RGBU16: return "RGBU16"
    case .RGBU16M2: return "RGBU16M2"
    case .RGBU16M4: return "RGBU16M4"
    case .RGBU16M8: return "RGBU16M8"
    case .RGBU16D16: return "RGBU16D16"
    case .RGBU16D16M2: return "RGBU16D16M2"
    case .RGBU16D16M4: return "RGBU16D16M4"
    case .RGBU16D16M8: return "RGBU16D16M8"
    case .RGBU16D24: return "RGBU16D24"
    case .RGBU16D24M2: return "RGBU16D24M2"
    case .RGBU16D24M4: return "RGBU16D24M4"
    case .RGBU16D24M8: return "RGBU16D24M8"
    case .RGBU16D32: return "RGBU16D32"
    case .RGBU16D32M2: return "RGBU16D32M2"
    case .RGBU16D32M4: return "RGBU16D32M4"
    case .RGBU16D32M8: return "RGBU16D32M8"
    case .RGBF32: return "RGBF32"
    case .RGBF32M2: return "RGBF32M2"
    case .RGBF32M4: return "RGBF32M4"
    case .RGBF32M8: return "RGBF32M8"
    case .RGBF32D16: return "RGBF32D16"
    case .RGBF32D16M2: return "RGBF32D16M2"
    case .RGBF32D16M4: return "RGBF32D16M4"
    case .RGBF32D16M8: return "RGBF32D16M8"
    case .RGBF32D24: return "RGBF32D24"
    case .RGBF32D24M2: return "RGBF32D24M2"
    case .RGBF32D24M4: return "RGBF32D24M4"
    case .RGBF32D24M8: return "RGBF32D24M8"
    case .RGBF32D32: return "RGBF32D32"
    case .RGBF32D32M2: return "RGBF32D32M2"
    case .RGBF32D32M4: return "RGBF32D32M4"
    case .RGBF32D32M8: return "RGBF32D32M8"
    case .RGBAU8: return "RGBAU8"
    case .RGBAU8M2: return "RGBAU8M2"
    case .RGBAU8M4: return "RGBAU8M4"
    case .RGBAU8M8: return "RGBAU8M8"
    case .RGBAU8D16: return "RGBAU8D16"
    case .RGBAU8D16M2: return "RGBAU8D16M2"
    case .RGBAU8D16M4: return "RGBAU8D16M4"
    case .RGBAU8D16M8: return "RGBAU8D16M8"
    case .RGBAU8D24: return "RGBAU8D24"
    case .RGBAU8D24M2: return "RGBAU8D24M2"
    case .RGBAU8D24M4: return "RGBAU8D24M4"
    case .RGBAU8D24M8: return "RGBAU8D24M8"
    case .RGBAU8D32: return "RGBAU8D32"
    case .RGBAU8D32M2: return "RGBAU8D32M2"
    case .RGBAU8D32M4: return "RGBAU8D32M4"
    case .RGBAU8D32M8: return "RGBAU8D32M8"
    case .RGBAU16: return "RGBAU16"
    case .RGBAU16M2: return "RGBAU16M2"
    case .RGBAU16M4: return "RGBAU16M4"
    case .RGBAU16M8: return "RGBAU16M8"
    case .RGBAU16D16: return "RGBAU16D16"
    case .RGBAU16D16M2: return "RGBAU16D16M2"
    case .RGBAU16D16M4: return "RGBAU16D16M4"
    case .RGBAU16D16M8: return "RGBAU16D16M8"
    case .RGBAU16D24: return "RGBAU16D24"
    case .RGBAU16D24M2: return "RGBAU16D24M2"
    case .RGBAU16D24M4: return "RGBAU16D24M4"
    case .RGBAU16D24M8: return "RGBAU16D24M8"
    case .RGBAU16D32: return "RGBAU16D32"
    case .RGBAU16D32M2: return "RGBAU16D32M2"
    case .RGBAU16D32M4: return "RGBAU16D32M4"
    case .RGBAU16D32M8: return "RGBAU16D32M8"
    case .RGBAF32: return "RGBAF32"
    case .RGBAF32M2: return "RGBAF32M2"
    case .RGBAF32M4: return "RGBAF32M4"
    case .RGBAF32M8: return "RGBAF32M8"
    case .RGBAF32D16: return "RGBAF32D16"
    case .RGBAF32D16M2: return "RGBAF32D16M2"
    case .RGBAF32D16M4: return "RGBAF32D16M4"
    case .RGBAF32D16M8: return "RGBAF32D16M8"
    case .RGBAF32D24: return "RGBAF32D24"
    case .RGBAF32D24M2: return "RGBAF32D24M2"
    case .RGBAF32D24M4: return "RGBAF32D24M4"
    case .RGBAF32D24M8: return "RGBAF32D24M8"
    case .RGBAF32D32: return "RGBAF32D32"
    case .RGBAF32D32M2: return "RGBAF32D32M2"
    case .RGBAF32D32M4: return "RGBAF32D32M4"
    case .RGBAF32D32M8: return "RGBAF32D32M8"
    case .RGBXU8: return "RGBXU8"
    case .RGBXU8M2: return "RGBXU8M2"
    case .RGBXU8M4: return "RGBXU8M4"
    case .RGBXU8M8: return "RGBXU8M8"
    case .RGBXU8D16: return "RGBXU8D16"
    case .RGBXU8D16M2: return "RGBXU8D16M2"
    case .RGBXU8D16M4: return "RGBXU8D16M4"
    case .RGBXU8D16M8: return "RGBXU8D16M8"
    case .RGBXU8D24: return "RGBXU8D24"
    case .RGBXU8D24M2: return "RGBXU8D24M2"
    case .RGBXU8D24M4: return "RGBXU8D24M4"
    case .RGBXU8D24M8: return "RGBXU8D24M8"
    case .RGBXU8D32: return "RGBXU8D32"
    case .RGBXU8D32M2: return "RGBXU8D32M2"
    case .RGBXU8D32M4: return "RGBXU8D32M4"
    case .RGBXU8D32M8: return "RGBXU8D32M8"
    case .RGBXU16: return "RGBXU16"
    case .RGBXU16M2: return "RGBXU16M2"
    case .RGBXU16M4: return "RGBXU16M4"
    case .RGBXU16M8: return "RGBXU16M8"
    case .RGBXU16D16: return "RGBXU16D16"
    case .RGBXU16D16M2: return "RGBXU16D16M2"
    case .RGBXU16D16M4: return "RGBXU16D16M4"
    case .RGBXU16D16M8: return "RGBXU16D16M8"
    case .RGBXU16D24: return "RGBXU16D24"
    case .RGBXU16D24M2: return "RGBXU16D24M2"
    case .RGBXU16D24M4: return "RGBXU16D24M4"
    case .RGBXU16D24M8: return "RGBXU16D24M8"
    case .RGBXU16D32: return "RGBXU16D32"
    case .RGBXU16D32M2: return "RGBXU16D32M2"
    case .RGBXU16D32M4: return "RGBXU16D32M4"
    case .RGBXU16D32M8: return "RGBXU16D32M8"
    case .RGBXF32: return "RGBXF32"
    case .RGBXF32M2: return "RGBXF32M2"
    case .RGBXF32M4: return "RGBXF32M4"
    case .RGBXF32M8: return "RGBXF32M8"
    case .RGBXF32D16: return "RGBXF32D16"
    case .RGBXF32D16M2: return "RGBXF32D16M2"
    case .RGBXF32D16M4: return "RGBXF32D16M4"
    case .RGBXF32D16M8: return "RGBXF32D16M8"
    case .RGBXF32D24: return "RGBXF32D24"
    case .RGBXF32D24M2: return "RGBXF32D24M2"
    case .RGBXF32D24M4: return "RGBXF32D24M4"
    case .RGBXF32D24M8: return "RGBXF32D24M8"
    case .RGBXF32D32: return "RGBXF32D32"
    case .RGBXF32D32M2: return "RGBXF32D32M2"
    case .RGBXF32D32M4: return "RGBXF32D32M4"
    case .RGBXF32D32M8: return "RGBXF32D32M8"
    }
  }

  var isU8: Bool        { return rawValue & PixFmtBitU8 != 0 }
  var isU16: Bool       { return rawValue & PixFmtBitU16 != 0 }
  var isF32: Bool       { return rawValue & PixFmtBitF32 != 0 }
  var hasAlpha: Bool    { return rawValue & PixFmtBitA != 0 }
  var skipsAlpha: Bool  { return rawValue & PixFmtBitX != 0 }
  var isLum: Bool       { return rawValue & PixFmtBitL != 0 }
  var isRGB: Bool       { return rawValue & PixFmtBitRGB != 0 }

  var bitsPerChannel: Int {
    if isF32 { return 32 }
    if isU16 { return 16 }
    assert(isU8, "bad PixFmt: \(self)")
    return 8
  }

  var channels: Int {
    var c = 0
    if isRGB {
      c = 3
    }
    else if isLum {
      c = 1
    }
    if hasAlpha || skipsAlpha {
      c += 1
    }
    return c
  }

  var bitsPerPixel: Int {
    return bitsPerChannel * channels
  }

  var bytesPerPixel: Int {
    assert(bitsPerPixel % 8 == 0, "irregular bits per pixel: \(bitsPerPixel)")
    return bitsPerPixel / 8
  }

  var bitmapInfo: CGBitmapInfo {
    var alpha = CGImageAlphaInfo.None
    var info = CGBitmapInfo(0)
    if isLum || isRGB {
      if hasAlpha {
        alpha = .PremultipliedLast
      }
      else if skipsAlpha {
        alpha = .NoneSkipLast
      }
    }
    else if hasAlpha {
      alpha = .Only
    }
    else {
      fatalError("bad PixFmt for bitmap: \(self)")
    }
    return CGBitmapInfo(alpha.rawValue | (isF32 ? CGBitmapInfo.FloatComponents.rawValue : 0))
  }

  var cgColorSpace: CGColorSpace {
    if isRGB { return CGColorSpaceCreateDeviceRGB() }
    if isLum { return CGColorSpaceCreateDeviceGray() }
    fatalError("PixFmt does not map ot CGColorSpace: \(self)")
  }

  var alphaSize: Int {
    if hasAlpha {
      return bitsPerChannel
    }
    return 0
  }

  var depthSize: Int {
    if rawValue & PixFmtBitD16 != 0 { return 16 }
    if rawValue & PixFmtBitD24 != 0 { return 24 }
    if rawValue & PixFmtBitD32 != 0 { return 32 }
    return 0
  }

  var multisamples: Int {
    if rawValue & PixFmtBitM2 != 0 { return 2 }
    if rawValue & PixFmtBitM4 != 0 { return 4 }
    if rawValue & PixFmtBitM8 != 0 { return 8 }
    return 0
  }

}

