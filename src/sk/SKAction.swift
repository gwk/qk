// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKAction {

  class func move(delta: CGVector, speed: Flt) -> SKAction {
    return SKAction.moveBy(delta * speed, duration: 1).forever
  }

  class func runNodeBlock<Node: SKNode>(block: (Node)->()) -> SKAction {
    return SKAction.customActionWithDuration(0) {
      (node: SKNode, elapsedTime: CGFloat) in
      if let node = node as? Node {
        block(node)
      } else {
        errL("runNodeBlock cast `SKNode as? \(Node.self)` failed for node: \(node)")
      }
    }
  }

  func delay(duration: Time) -> SKAction { return SKAction.sequence([SKAction.waitForDuration(duration), self]) }

  func repeated(count: Int) -> SKAction { return SKAction.repeatAction(self, count: count) }

  var forever: SKAction { return SKAction.repeatActionForever(self) }
}
