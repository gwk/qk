// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKPhysicsBody {

  convenience init(polygonPoints: [CGPoint]) {
    self.init(polygonFrom: CGPath.with(loopPoints: polygonPoints))
  }

  convenience init(edgeLoopPoints: [CGPoint]) {
    self.init(edgeLoopFrom: CGPath.with(loopPoints: edgeLoopPoints))
  }

  #if false // this compiles and links but results in unrecognized selector.
  convenience init(size: CGSize, anchor: CGPoint) {
    self.init(rectangleOfSize: size, center: V2(size) * (V2(0.5, 0.5) - anchor))
  }
  #endif

  class func with(size: CGSize, anchor: CGPoint) -> SKPhysicsBody { // workaround for above.
    return SKPhysicsBody(rectangleOf: size, center: V2(size) * (V2(0.5, 0.5) - anchor))
  }

  class func matching(spriteNode: SKSpriteNode) -> SKPhysicsBody {
    return SKPhysicsBody.with(size: spriteNode.size, anchor: spriteNode.anchorPoint)
  }
}
