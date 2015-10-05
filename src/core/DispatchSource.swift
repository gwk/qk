// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


typealias DispatchSource = dispatch_source_t


extension DispatchSource {

  func resume() { dispatch_resume(self) }

  func suspend() { dispatch_suspend(self) }

  func cancel() { dispatch_source_cancel(self) }

  func getData() -> Uns { return dispatch_source_get_data(self) }

  var isCanceled: Bool { return dispatch_source_testcancel(self) != 0 }
}