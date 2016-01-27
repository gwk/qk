// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKNode {

  convenience init(name: String) {
    self.init()
    self.name = name
  }
  
  func add<T: SKNode>(child: T) -> T {
    addChild(child)
    return child
  }

  func addChildren(children: [SKNode]) {
    for c in children {
      addChild(c)
    }
  }
}