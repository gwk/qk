// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import SceneKit


extension SCNNode {

  convenience init(name: String?) {
    self.init()
    self.name = name
  }
}
