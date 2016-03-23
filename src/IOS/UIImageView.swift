// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


extension UIImageView {

  convenience init(name: String, parent: UIView? = nil, _ imageName: String, _ litImageName: String? = nil) {
    self.init(image: UIImage(imageName))
    helpInit(name: name, parent: parent, flex: nil)
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

