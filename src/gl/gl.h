// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#import <OpenGL/OpenGL.h>

typedef GLuint GLHandle;

#if TARGET_OS_IPHONE
typedef EAGLContext* GLContext;
#else
typedef CGLContextObj GLContext;
#endif


void glContextEnable(GLContext ctx);

void glDeleteTexture(GLHandle texture);

void glShaderSource1(GLHandle shader, const char* source, int len);
