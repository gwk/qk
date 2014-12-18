// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


struct ViewVert {
  var pos: V2F32
  var tex: V2F32
}

struct ViewQuad {
  var a: TextVert
  var b: TextVert
  var c: TextVert
  var d: TextVert
}


protocol GLView {
 
  var program: GLProgram { get }
  var tex: GLTexture? { get }

}


class GLViewBasic: GLView {
  var program: GLProgram
  var tex: GLTexture?
  
  init(program: GLProgram, tex: GLTexture?) {
    self.program = program
    self.tex = tex
  }
}
