// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#import <stdio.h>
#import "gl.h"


void glContextEnable(GLContext ctx) {
#if TARGET_OS_IPHONE
  [EAGLContext setCurrentContext:ctx];
#else
  CGLError error = CGLSetCurrentContext(ctx);
  if (error != kCGLNoError) {
    fprintf(stderr, "ERROR: %s: %i", __func__, error);
  }
#endif
}


void glDeleteTexture(_GLHandle texture) {
  glDeleteTextures(1, &texture);
}


void glShaderSource1(_GLHandle shader, const char* source, int len) {
  glShaderSource(shader, 1, &source, &len);
}
