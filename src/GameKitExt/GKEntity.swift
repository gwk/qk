// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import GameKit


@available(OSX 10.11, *)
extension GKEntity {

  func addComponents(_ components: GKComponent...) {
    for c in components {
      addComponent(c)
      c.onAdd()
    }
  }
}
