// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIImageView {

  convenience init(n: String, p: UIView? = nil, _ imageName: String, _ litImageName: String? = nil) {
    self.init(image: UIImage(imageName))
    helpInit(n, p)
    if let lin = litImageName {
      self.highlightedImage = UIImage(lin)
    }
  }

  var lit: Bool {
    get { return highlighted }
    set { highlighted = newValue }
  }
  
  var litImage: UIImage? {
    get { return highlightedImage }
    set { highlightedImage = newValue }
  }
}

