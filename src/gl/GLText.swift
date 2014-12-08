// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


struct TextVert {
  var pos: V2F32
  var tex: V2F32
}

struct TextQuad {
  var a: TextVert
  var b: TextVert
  var c: TextVert
  var d: TextVert
}


class GLTextState: Hashable {
  // stores the state that GLTextCache needs to update the textures.
  var text: String = ""
  var size: Int = 16
  
  var hashValue: Int { return ObjectIdentifier(self).hashValue }
}

func ==(a: GLTextState, b: GLTextState) -> Bool { return a === b }


class GLText {
  var state: GLTextState = GLTextState()
  var _kern: Flt = 0
  var quads: [TextVert] = []
  var tex: GLTexture? = nil
  var atlas: GLTextAtlas
  
  init(atlas: GLTextAtlas) {
    self.atlas = atlas
  }
  
  var text: String {
    get { return state.text }
    set { // GLTextCache needs to know that
      if state.text == newValue { return }
      state.text = newValue
      atlas.addState(state)
      quads.removeAll()
    }
  }
  
  var size: Int {
    get { return state.size }
    set {
      if state.size == newValue { return }
      state.size = newValue
      atlas.addState(state)
    }
  }
  
  var kern: Flt {
    get { return _kern }
    set {
      if _kern == newValue { return }
      _kern = newValue
      quads.removeAll()
    }
  }
}


struct GLTextPage {
  let width: Int
  let tex: GLTexture = GLTexture()
  let ctx: CGContext
  let glyphs: [[U8]] = []
  
  init(width: Int) {
    self.width = width

    var cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()
    
    let info = CGBitmapInfo(CGImageAlphaInfo.None.rawValue | CGBitmapInfo.ByteOrderDefault.rawValue)
    self.ctx = CGBitmapContextCreate(nil, // manage data internally.
      Uns(width),
      Uns(width * 2),
      8, // bits per channel.
      Uns(width), // bytes per row.
      cs,
      info)
  }
  
  func render(chars: [Character]) {
    
  }
}


class GLTextAtlas {
  let fontName = "Source Code Pro"
  var charIndexes: [Character:Int] = [:]
  var pages: [Int:GLTextPage] = [:] // keyed by width.
  var dirtyStates: [GLTextState:Bool] = [:] // dict-as-set.
  
  func addState(state: GLTextState) {
    dirtyStates[state] = true
  }
  
  func render() {

  }
  
  func update() {
    var dirty = false
    for (state, b) in dirtyStates {
      for c in state.text {
        if let i = charIndexes[c] {
        } else {
          charIndexes[c] = charIndexes.count
          // render
          dirty = true
        }
      }
    }
    if dirty { // update textures.
      for (width, tex) in pages {
       //
      }
    }
  }
}
