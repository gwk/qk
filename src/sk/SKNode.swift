// © 2015 George King. All rights reserved.

import SpriteKit


extension SKNode {

  func add<T: SKNode>(child: T) -> T {
    addChild(child)
    return child
  }

  func addAll(children: [SKNode]) {
    for c in children {
      addChild(c)
    }
  }
}