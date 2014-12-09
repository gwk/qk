// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIImageView {

  convenience init(n: String, _ imageName: String, _ litImageName: String?=nil) {
    self.init(image: UIImage(imageName))
    if let n = litImageName {
      self.highlightedImage = UIImage(n)
    }
    name = n
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

