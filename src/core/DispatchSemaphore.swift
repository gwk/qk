// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


typealias DispatchSemaphore = dispatch_semaphore_t

func DispatchSemaphoreWithCount(count: Int) -> DispatchSemaphore {
  return dispatch_semaphore_create(count)!
}


extension DispatchSemaphore {

  func signal() { dispatch_semaphore_signal(self) }

  func wait(until: DispatchTime = .forever) { dispatch_semaphore_wait(self, until) }

}
