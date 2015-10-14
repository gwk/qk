// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import GameKit


extension GKEntity {

  func addComponents(components: GKComponent...) {
    for c in components {
      addComponent(c)
      c.onAdd()
    }
  }
}