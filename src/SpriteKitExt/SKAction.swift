// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKAction {

  class func runNodeBlock<Node: SKNode>(_ block: (Node)->()) -> SKAction {
    return SKAction.customAction(withDuration: 0) {
      (node: SKNode, elapsedTime: CGFloat) in
      if let node = node as? Node {
        block(node)
      } else {
        errL("runNodeBlock cast `SKNode as? \(Node.self)` failed for node: \(node)")
      }
    }
  }

  func delay(_ duration: Time) -> SKAction { return SKAction.sequence([SKAction.wait(forDuration: duration), self]) }

  func repeated(_ count: Int) -> SKAction { return SKAction.repeat(self, count: count) }

  var forever: SKAction { return SKAction.repeatForever(self) }

  class func showTexts(_ texts: [String], durationPerItem: Time) -> SKAction {
    var actions: [SKAction] = [SKAction.unhide()]
    for text in texts {
      actions.append(SKAction.runNodeBlock {
        (node: SKLabelNode) in
        node.text = text
      })
      actions.append(SKAction.wait(forDuration: durationPerItem))
    }
    actions.append(SKAction.hide())
    return SKAction.sequence(actions)
  }
}
