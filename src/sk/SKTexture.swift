// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreImage
import SpriteKit


let missingResourceImage = try! CGImageRef.with(path: pathForResource("missing.png"))

extension SKTexture {

  convenience init(path: String, filteringMode: SKTextureFilteringMode = .Linear) {
    let image: CGImageRef
    do {
      image = try CGImageRef.with(path: path)
    } catch let e {
      warn("texture resource load failed: \(e)")
      image = missingResourceImage
    }
    self.init(CGImage: image)
    self.filteringMode = filteringMode
  }

  class func missing() -> SKTexture { return SKTexture(CGImage: missingResourceImage) }

  var textureByFlippingH: SKTexture {
    return SKTexture(CGImage: self.CGImage.flipH())
  }
}
