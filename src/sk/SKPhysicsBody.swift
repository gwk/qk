// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKPhysicsBody {

  convenience init(edgeLoopPoints: [CGPoint]) {
    let path = CGPathCreateMutable()
    path.addLines(edgeLoopPoints)
    self.init(edgeLoopFromPath: path)
  }
}
