// © 2016 George King. Permission to use this file is granted in license.txt.

import Foundation


class Ref<Val> {
  var val: Val

  init(_ val: Val) {
    self.val = val
  }
}


extension Ref where Val: DefaultInitializable {
  convenience init() {
    self.init(Val())
  }
}
