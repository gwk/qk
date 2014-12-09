// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import UIKit


extension UICollectionView {
  convenience init(n: String, layout: UICollectionViewLayout) {
    self.init(frame: frameInit, collectionViewLayout: layout)
    name = n
  }
}

