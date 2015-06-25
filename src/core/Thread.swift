// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


let processorCount = sysconf(_SC_NPROCESSORS_CONF)


class Thread: NSThread {
  
  let action: Action
  
  init(name: String, action: Action) {
    self.action = action
    super.init()
    self.name = name
  }
  
  override func main() {
    action()
  }
}


func spawnThread(name: String, action: Action) -> Thread {
  let thread = Thread(name: name, action: action)
  thread.start()
  return thread
}
