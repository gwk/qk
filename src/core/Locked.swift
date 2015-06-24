// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


struct Locked<T: AnyObject> {
  // T must be a class type; otherwise it would have value semantics and locking would be pointless.
  
  private let _protected: T
  private let _semaphore: dispatch_semaphore_t
  
  init(_ initial: T) {
    _protected = initial
    _semaphore = dispatch_semaphore_create(1) // allow a single accessor at a time.
  }
  
  func access<R>(@noescape accessor: (T) -> R) -> R {
    // access the locked data.
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER)
    let ret = accessor(_protected)
    dispatch_semaphore_signal(_semaphore)
    return ret
  }
}

