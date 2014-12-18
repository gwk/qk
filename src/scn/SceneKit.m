// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#import "SceneKit.h"
#import "gl.h"


void SCNSceneRenderer_activateContext(id<SCNSceneRenderer> renderer) {
  glContextEnable([renderer context]);
}
