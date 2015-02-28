// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#import <SceneKit/SceneKit.h>

void SCNSceneRenderer_activateContext(id<SCNSceneRenderer> renderer);

// hack to avoid dealing with search paths: just duplicate these declarations.
typedef GLuint _GLHandle;
void glDeleteTexture(_GLHandle texture);
void glShaderSource1(_GLHandle shader, const char* source, int len);
