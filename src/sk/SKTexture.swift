// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import SpriteKit


extension SKTexture {

  convenience init(path: String, filteringMode: SKTextureFilteringMode = .Linear) {
    let image: CGImageRef
    do {
      image = try CGImageRef.with(path: path)
    } catch let e {
      warn("texture resource load failed: \(e)")
      image = try! CGImageRef.with(path: pathForResource("missing.png"))
    }
    self.init(CGImage: image)
    self.filteringMode = filteringMode
  }
}
