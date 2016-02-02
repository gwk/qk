// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKPhysicsBody {

  convenience init(edgeLoopPoints: [CGPoint]) {
    self.init(edgeLoopFromPath: CGPath.with(loopPoints: edgeLoopPoints))
  }


  class func matching(spriteNode spriteNode: SKSpriteNode) -> SKPhysicsBody {
    return SKPhysicsBody(rectangleOfSize: spriteNode.size, center: V2(spriteNode.size) * (V2(0.5, 0.5) - spriteNode.anchorPoint))
  }
}
