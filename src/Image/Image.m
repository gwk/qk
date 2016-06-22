// Copyright 2015 George King. Permission to use this file is granted in license-qk.txt.

#import <png.h>
#import <zlib.h>
#import "Image.h"


void logPngVersionInfo() {
  fprintf(stderr, "libpng compiled: %s; using: %s; zlib compiled: %s; using: %s",
          PNG_LIBPNG_VER_STRING, png_libpng_ver, ZLIB_VERSION, "unknwon");
}


void* imgDataFromPngReadPtr(png_structp readPtr,
                            png_infop infoPtr,
                            NSString* name,
                            BOOL requireFmt,
                            BOOL gammaCorrect,
                            double displayExponent,
                            NSInteger* wPtr,
                            NSInteger* hPtr,
                            BOOL* hasRGBPtr,
                            BOOL* hasAlphaPtr,
                            BOOL* is16BitPtr,
                            NSError** errorPtr) {
  
  png_bytep data = NULL;
  png_bytepp row_pointers = NULL;

  // setjmp() must be called prior to libng read function calls.
#ifdef PNG_SETJMP_SUPPORTED
  if (setjmp(png_jmpbuf(readPtr))) {
    free(data);
    free(row_pointers);
    if (errorPtr) {
      *errorPtr = [NSError errorWithDomain:@"Image"
                                      code:1
                                  userInfo:@{NSLocalizedDescriptionKey: @"PNG read failed", @"name" : name}];
      
    }
    return NULL;
  }
#endif
  
  png_read_info(readPtr, infoPtr);
  
  png_uint_32 w, h;
  int srcBitDepth;
  int colorType;
  int interlaceType;
  int compressionType;
  int filterType;
  
  png_get_IHDR(readPtr, infoPtr, &w, &h, &srcBitDepth, &colorType, &interlaceType, &compressionType, &filterType);
  *wPtr = w;
  *hPtr = h;
  BOOL srcHasRGB = colorType | PNG_COLOR_MASK_COLOR;
  BOOL srcHasAlpha = colorType | PNG_COLOR_MASK_ALPHA;
  
  NSInteger dstHasRGB = srcHasRGB;
  NSInteger dstHasAlpha = srcHasAlpha;
  NSInteger dstBitDepth = srcBitDepth;
  if (requireFmt) {
    dstHasRGB = *hasRGBPtr;
    dstHasAlpha = *hasAlphaPtr;
    dstBitDepth = (*is16BitPtr ? 16 : 8);
    assert(dstBitDepth == 8); // 16 bit is not yet supported.
  }
  if (colorType == PNG_COLOR_TYPE_PALETTE) { // extend palette images to RGB.
    png_set_expand(readPtr);
    dstBitDepth = 8;
  }
  if (png_get_valid(readPtr, infoPtr, PNG_INFO_tRNS)) { // expand transparency chunks to full alpha channel.
    png_set_expand(readPtr);
    dstBitDepth = 8;
  }
  if (srcBitDepth < 8) { // expand low bit depth images to 8 bits.
    png_set_expand(readPtr);
    dstBitDepth = 8;
  }
  if (srcBitDepth == 16) { // scale 16-bit images to 8 bit.
    png_set_scale_16(readPtr);
    dstBitDepth = 8;
  }
  
  if (requireFmt) {
    if (dstHasRGB && !srcHasRGB) { // convert grayscale to RGB.
      png_set_gray_to_rgb(readPtr);
    } else if (!dstHasRGB && srcHasRGB) { // convert RGB to grayscale.
      png_set_rgb_to_gray(readPtr, PNG_ERROR_ACTION_WARN, PNG_RGB_TO_GRAY_DEFAULT, PNG_RGB_TO_GRAY_DEFAULT);
    }
    if (dstHasAlpha && !srcHasAlpha) { // add alpha channel.
      png_set_add_alpha(readPtr, 255, PNG_FILLER_AFTER);
    } else if (!dstHasAlpha && srcHasAlpha) { // strip alpha channel.
      png_set_strip_alpha(readPtr);
    }
  }
  
  // unlike the example in the libpng documentation, we have no idea where this file may have come from;
  // therefore if it does not have a file gamma, do not do any correction.
  double gamma = 0;
  if (gammaCorrect && png_get_gAMA(readPtr, infoPtr, &gamma)) {
    png_set_gamma(readPtr, displayExponent, gamma);
  }
  
  // all transformations have been registered; update infoPtr.
  png_read_update_info(readPtr, infoPtr);
  
  int channels = png_get_channels(readPtr, infoPtr);
  size_t rowsLength = png_get_rowbytes(readPtr, infoPtr);
  if (rowsLength != h * channels * dstBitDepth / 8) {
    if (errorPtr) {
      *errorPtr = [NSError errorWithDomain:@"Image"
                                      code:1
                                  userInfo:@{NSLocalizedDescriptionKey : @"unexpected rows array byte length",
                                             @"name" : name,
                                             @"length" : @(rowsLength),
                                             @"w" : @(w),
                                             @"h" : @(h),
                                             @"channels" : @(channels),
                                             @"depth" : @(dstBitDepth)}];
    }
    return NULL;
  }
  
  size_t l =  rowsLength * h;
  data = (png_bytep)malloc(l);
  row_pointers = (png_bytepp)malloc(h * sizeof(png_bytep));
  // fill out row_pointers.
  const BOOL flip = YES; // make data layout match OpenGL texturing expectations.
  for (int i = 0; i < h; i++) {
    row_pointers[flip ? ((h - 1) - i) : i] = data + i * rowsLength;
  }
  // read data.
  png_read_image(readPtr, row_pointers);
  free(row_pointers);
  return data;
}


void pngErrorFn(png_structp png_ptr, png_const_charp error_msg) {
  static NSDictionary* explanations = nil;
  if (!explanations) {
    explanations =
    @{@"CgBI: unknown critical chunk" : @"The PNG file was most likely mangled by Xcode during iOS 'Copy Resources' build phase."};
  };
  NSString* e = [explanations objectForKey:[NSString stringWithUTF8String:error_msg]];
  NSLog(@"PNG error: %s", error_msg);
  if (e) {
    NSLog(@"  %@", e);
  }
}


void* imgDataFromPngFile(CFile file,
                         NSString* name,
                         BOOL requireFmt,
                         BOOL gammaCorrect,
                         double displayExponent,
                         NSInteger* wPtr,
                         NSInteger* hPtr,
                         BOOL* hasRGBPtr,
                         BOOL* hasAlphaPtr,
                         BOOL* is16BitPtr,
                         NSError** errorPtr) {
  png_byte sig[8];
  fread(sig, 1, 8, file);
  if (!png_check_sig(sig, 8)) {
    if (errorPtr) {
      *errorPtr = [NSError errorWithDomain:@"Image"
                                      code:1
                                  userInfo:@{NSLocalizedDescriptionKey : @"bad PNG signature",
                                             @"name" : name}];
    }
    return NULL;
  }
  png_voidp error_ptr = NULL;
  png_error_ptr warn_fn = NULL;
  png_structp readPtr = png_create_read_struct(PNG_LIBPNG_VER_STRING, error_ptr, pngErrorFn, warn_fn);
  if (!readPtr) {
    if (errorPtr) {
      *errorPtr = [NSError errorWithDomain:@"Image"
                                      code:1
                                  userInfo:@{NSLocalizedDescriptionKey : @"png_create_read_struct failed (out of memory?)",
                                             @"name" : name}];
    }
    return NULL;
  }
  png_infop infoPtr = png_create_info_struct(readPtr);
  if (!readPtr) {
    if (errorPtr) {
      *errorPtr = [NSError errorWithDomain:@"Image"
                                      code:1
                                  userInfo:@{NSLocalizedDescriptionKey : @"png_create_info_struct failed (out of memory?)",
                                             @"name" : name}];
    }
    return NULL;
  }
  png_init_io(readPtr, file);
  png_set_sig_bytes(readPtr, 8); // since we already read the signature bytes
  
  void* data = imgDataFromPngReadPtr(readPtr, infoPtr, name, requireFmt, gammaCorrect, displayExponent,
                                     wPtr, hPtr, hasRGBPtr, hasAlphaPtr, is16BitPtr, errorPtr);
  
  png_destroy_read_struct(&readPtr, &infoPtr, NULL);
  return data;
}



