// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


enum GLTouchState {
  case none
  case down
  case drag
  case up
}

struct GLKeyMods: OptionSet {
  let rawValue: Uns
  init(rawValue: Uns) { self.rawValue = rawValue }

  static let None       = GLKeyMods(rawValue: 0x00)
  static let ShiftAlpha = GLKeyMods(rawValue: 0x01)
  static let Shift      = GLKeyMods(rawValue: 0x02)
  static let Ctrl       = GLKeyMods(rawValue: 0x04)
  static let Alt        = GLKeyMods(rawValue: 0x08)
  static let Cmd        = GLKeyMods(rawValue: 0x10)
  static let NumPad     = GLKeyMods(rawValue: 0x20)
  static let Help       = GLKeyMods(rawValue: 0x40)
  static let Fn         = GLKeyMods(rawValue: 0x80)
}

enum GLMouseButton: Uns {
  case none   = 0x0
  case left   = 0x1
  case right  = 0x2
  case middle = 0x4
  case b3     = 0x8
  // B4, etc. as necessary.
}

enum GLKeyState {
  case none
  case down
  case up
}

struct GLTouch {
  let time: Time
  let pos: CGPoint
  let button: GLMouseButton
  let state: GLTouchState
  let mods: GLKeyMods
}

struct GLKey {
  let time: Time
  let code: U16
  let mods: GLKeyMods
  let state: GLKeyState
  let chars: String
  let charsUnmodified: String
}


struct GLTick {
  let time: Time
}


enum GLEvent {
  case ignored
  case touch(GLTouch)
  case key(GLKey)
  case tick(GLTick)
}


func glEventFrom(_ event: CREvent, view: CRView) -> GLEvent {
  #if os(OSX)
  func touchPos() -> CGPoint { return view.convert(event.locationInWindow, from: nil) }
  func mods() -> GLKeyMods { return GLKeyMods() } // TODO

  switch event.type {
  case .leftMouseDown:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.left, state:.down, mods:mods()))
  case .leftMouseUp:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.left, state:.up, mods:mods()))
  case .rightMouseDown:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.right, state:.down, mods:mods()))
  case .rightMouseUp:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.right, state:.up, mods:mods()))
  case .mouseMoved:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.none, state:.none, mods:mods()))
  case .leftMouseDragged:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.left, state:.drag, mods:mods()))
  case .rightMouseDragged:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.right, state:.drag, mods:mods()))
  case .mouseEntered:
    return .ignored
  case .mouseExited:
    return .ignored
  case .keyDown:
    return .key(GLKey(time:event.appTime, code:event.keyCode, mods:mods(), state:.down, chars:event.characters.or(""),
      charsUnmodified:event.charactersIgnoringModifiers.or("")))
  case .keyUp:
    return .key(GLKey(time:event.appTime, code:event.keyCode, mods:mods(), state:.up, chars:event.characters.or(""),
      charsUnmodified:event.charactersIgnoringModifiers.or("")))
  case .flagsChanged:
    return .key(GLKey(time:event.appTime, code:0, mods:mods(), state:.none, chars:"", charsUnmodified:""))
  case .appKitDefined:
    return .ignored
  case .systemDefined:
    return .ignored
  case .applicationDefined:
    return .ignored
  case .periodic:
    return .ignored
  case .cursorUpdate:
    return .ignored
  case .scrollWheel:
    return .ignored
  case .tabletPoint:
    return .ignored
  case .tabletProximity:
    return .ignored
  case .otherMouseDown:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.middle, state:.down, mods:mods()))
  case .otherMouseUp:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.middle, state:.up, mods:mods()))
  case .otherMouseDragged:
    return .touch(GLTouch(time:event.appTime, pos:touchPos(), button:.middle, state:.drag, mods:mods()))
  case .gesture:
    return .ignored
  case .magnify:
    return .ignored
  case .swipe:
    return .ignored
  case .rotate:
    return .ignored
  case .beginGesture:
    return .ignored
  case .endGesture:
    return .ignored
  case .smartMagnify:
    return .ignored
  case .quickLook:
    return .ignored
  case .pressure:
    return .ignored
  }
  #else // ios
  // TODO
  return .Ignored
  #endif
}

