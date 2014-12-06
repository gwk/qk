// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#import <OpenGL/gl3.h>
#import "gl.h"


void glDeleteTexture(GLHandle texture) {
  glDeleteTextures(1, &texture);
}


void glShaderSource1(GLHandle shader, const char* source, int len) {
  glShaderSource(shader, 1, &source, &len);
}
