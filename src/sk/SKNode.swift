// © 2015 George King. Permission to use this file is granted in license-qk.txt.

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