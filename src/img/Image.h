// Copyright 2015 George King.
// Permission to use this file is granted in license-qk.txt.

#import <Foundation/Foundation.h>

typedef FILE* CFile;

void logPngVersionInfo();

// displayExponent == LUT_exponent * CRT_exponent.
// requireFmt: if YES, require format specified in bitDepthPtr, hasRGBPtr, hasAlphaPtr.
// otherwise, return the natural format values of those images via those pointer parameters.
// note: for now, only 8 bit depth is supported.
void* imgDataFromPngFile(FILE* file,
                         NSString* name,
                         BOOL requireFmt,
                         BOOL gammaCorrect,
                         double displayExponent,
                         NSInteger* wPtr,
                         NSInteger* hPtr,
                         BOOL* hasRGBPtr,
                         BOOL* hasAlphaPtr,
                         BOOL* is16BitPtr,
                         NSError** errorPtr);
