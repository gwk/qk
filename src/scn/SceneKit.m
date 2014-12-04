// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#import "SceneKit.h"


void SCNSceneRenderer_activateContext(id<SCNSceneRenderer> renderer) {
  CGLContextObj ctx = [renderer context];
  CGLError error = CGLSetCurrentContext(ctx);
  if (error != kCGLNoError) {
    NSLog(@"ERROR: %s: %i", __func__, error);
  }
}
