// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


extension UICollectionView {
  convenience init(n: String, p: UIView? = nil, layout: UICollectionViewLayout) {
    self.init(frame: frameInit, collectionViewLayout: layout)
    helpInit(name: n, parent: p)
  }
}

