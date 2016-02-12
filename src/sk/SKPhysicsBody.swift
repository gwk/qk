// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKPhysicsBody {

  convenience init(edgeLoopPoints: [CGPoint]) {
    self.init(edgeLoopFromPath: CGPath.with(loopPoints: edgeLoopPoints))
  }

  convenience init(size: CGSize, anchorPoint: CGPoint) {
    self.init(rectangleOfSize: size, center: V2(size) * (V2(0.5, 0.5) - anchorPoint))
  }

  class func matching(spriteNode spriteNode: SKSpriteNode) -> SKPhysicsBody {
    return SKPhysicsBody(size: spriteNode.size, anchorPoint: spriteNode.anchorPoint)
  }
}
