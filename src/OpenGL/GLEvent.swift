// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


enum GLTouchState {
  case None
  case Down
  case Drag
  case Up
}

struct GLKeyMods: OptionSetType {
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
  case None   = 0x0
  case Left   = 0x1
  case Right  = 0x2
  case Middle = 0x4
  case B3     = 0x8
  // B4, etc. as necessary.
}

enum GLKeyState {
  case None
  case Down
  case Up
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
  case Ignored
  case Touch(GLTouch)
  case Key(GLKey)
  case Tick(GLTick)
}


func glEventFrom(event: CREvent, view: CRView) -> GLEvent {
  #if os(OSX)
  func touchPos() -> CGPoint { return view.convertPoint(event.locationInWindow, fromView: nil) }
  func mods() -> GLKeyMods { return GLKeyMods() } // TODO

  switch event.type {
  case .LeftMouseDown:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Left, state:.Down, mods:mods()))
  case .LeftMouseUp:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Left, state:.Up, mods:mods()))
  case .RightMouseDown:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Right, state:.Down, mods:mods()))
  case .RightMouseUp:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Right, state:.Up, mods:mods()))
  case .MouseMoved:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.None, state:.None, mods:mods()))
  case .LeftMouseDragged:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Left, state:.Drag, mods:mods()))
  case .RightMouseDragged:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Right, state:.Drag, mods:mods()))
  case .MouseEntered:
    return .Ignored
  case .MouseExited:
    return .Ignored
  case .KeyDown:
    return .Key(GLKey(time:event.appTime, code:event.keyCode, mods:mods(), state:.Down, chars:event.characters.or(""),
      charsUnmodified:event.charactersIgnoringModifiers.or("")))
  case .KeyUp:
    return .Key(GLKey(time:event.appTime, code:event.keyCode, mods:mods(), state:.Up, chars:event.characters.or(""),
      charsUnmodified:event.charactersIgnoringModifiers.or("")))
  case .FlagsChanged:
    return .Key(GLKey(time:event.appTime, code:0, mods:mods(), state:.None, chars:"", charsUnmodified:""))
  case .AppKitDefined:
    return .Ignored
  case .SystemDefined:
    return .Ignored
  case .ApplicationDefined:
    return .Ignored
  case .Periodic:
    return .Ignored
  case .CursorUpdate:
    return .Ignored
  case .ScrollWheel:
    return .Ignored
  case .TabletPoint:
    return .Ignored
  case .TabletProximity:
    return .Ignored
  case .OtherMouseDown:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Middle, state:.Down, mods:mods()))
  case .OtherMouseUp:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Middle, state:.Up, mods:mods()))
  case .OtherMouseDragged:
    return .Touch(GLTouch(time:event.appTime, pos:touchPos(), button:.Middle, state:.Drag, mods:mods()))
  case .EventTypeGesture:
    return .Ignored
  case .EventTypeMagnify:
    return .Ignored
  case .EventTypeSwipe:
    return .Ignored
  case .EventTypeRotate:
    return .Ignored
  case .EventTypeBeginGesture:
    return .Ignored
  case .EventTypeEndGesture:
    return .Ignored
  case .EventTypeSmartMagnify:
    return .Ignored
  case .EventTypeQuickLook:
    return .Ignored
  case .EventTypePressure:
    return .Ignored
  }
  #else // ios
  // TODO
  return .Ignored
  #endif
}

