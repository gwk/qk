// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSIndexPath {

  convenience init(s: Int, r: Int) { self.init(indexes: [s, r], length: 2) }
}
