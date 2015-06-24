// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


let processorCount = sysconf(_SC_NPROCESSORS_CONF)


class Thread: NSThread {
  
  let action: Action
  
  init(action: Action) {
    self.action = action
    super.init()
  }
  
  override func main() {
    action()
  }
}


func spawnThread(action: Action) -> Thread {
  let thread = Thread(action: action)
  thread.start()
  return thread
}
