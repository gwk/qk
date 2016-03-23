// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import UIKit


extension UICollectionView {
  convenience init(name: String, parent: UIView? = nil, layout: UICollectionViewLayout) {
    self.init(frame: frameInit, collectionViewLayout: layout)
    helpInit(name: name, parent: parent, flex: nil)
  }
}

