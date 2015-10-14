// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import GameKit


extension GKComponentSystem {

  class func systemsForClasses(classes: GKComponent.Type...) -> [GKComponentSystem] {
    return classes.map {
      GKComponentSystem(componentClass: $0)
    }
  }
}