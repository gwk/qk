// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreImage
import SpriteKit


let SKTexture_missing: SKTexture = SKTexture(CGImage: CoreGraphics.CGImage.missing) // workaround for 2.1b3.


extension SKTexture {

  static var missing: SKTexture { return SKTexture_missing }

  convenience init(path: String, filteringMode: SKTextureFilteringMode = .Linear) {
    let image: CGImageRef
    do {
      image = try CGImageRef.with(path: path)
    } catch let e {
      warn("texture resource load failed: \(e)")
      image = CoreGraphics.CGImage.missing
    }
    self.init(CGImage: image)
    self.filteringMode = filteringMode
  }

  var textureByFlippingH: SKTexture {
    return SKTexture(CGImage: self.CGImage.flipH())
  }
}
