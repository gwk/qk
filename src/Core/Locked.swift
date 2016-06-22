// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


class Locked<T: AnyObject> {
  // T must be a class type; otherwise it would have value semantics and locking would be pointless.
  
  private let _protected: T
  private let _semaphore: DispatchSemaphore
  
  var blockedCount: Int = 0
  var accessCount: Int = 0
  
  init(_ initial: T) {
    _protected = initial
    _semaphore = DispatchSemaphore(value: 1) // allow a single accessor at a time.
  }
  
  func access<R>(_ accessor: @noescape (T) -> R) -> R {
    // access the locked data.
    _semaphore.wait(timeout: DispatchTime.distantFuture)
    let ret = accessor(_protected)
    let didAwakeBlocked = _semaphore.signal()
    if (didAwakeBlocked != 0) {
      blockedCount += 1
    }
    accessCount += 1
    return ret
  }
  
  @warn_unused_result
  func statsDesc() -> String {
    return "frac: \(Float(blockedCount) / Float(accessCount)); blocked: \(blockedCount); total: \(accessCount)."
  }
}

