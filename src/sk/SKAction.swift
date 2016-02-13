// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKAction {

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

  class func showTexts(texts: [String], durationPerItem: Time) -> SKAction {
    var actions: [SKAction] = [SKAction.unhide()]
    for text in texts {
      actions.append(SKAction.runNodeBlock {
        (node: SKLabelNode) in
        node.text = text
      })
      actions.append(SKAction.waitForDuration(durationPerItem))
    }
    actions.append(SKAction.hide())
    return SKAction.sequence(actions)
  }
}
