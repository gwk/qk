// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKNode {

  convenience init(name: String) {
    self.init()
    self.name = name
  }

  var pos: V2 {
    get { return position }
    set { position = newValue }
  }


  func add<T: SKNode>(_ child: T) -> T {
    addChild(child)
    return child
  }

  func addChildren(_ children: [SKNode]) {
    for c in children {
      addChild(c)
    }
  }
}
