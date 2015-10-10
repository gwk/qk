// © 2015 George King. All rights reserved.

import SpriteKit


extension SKTexture {

  convenience init(resPath: String) {
    let image: CGImageRef
    do {
      image = try CGImageRef.with(path: pathForResource(resPath))
    } catch let e {
      warn("texture resource load failed: \(e)")
      image = try! CGImageRef.with(path: pathForResource("missing.png"))
    }
    self.init(CGImage: image)
  }
}
