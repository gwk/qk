// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKAction {

  class func move(delta: CGVector, speed: Flt) -> SKAction {
    return SKAction.moveBy(delta * speed, duration: 1).forever
  }

  func repeated(count: Int) -> SKAction { return SKAction.repeatAction(self, count: count) }

  var forever: SKAction { return SKAction.repeatActionForever(self) }
}
