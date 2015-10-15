// Copyright © 2015 George King. Permission to use this file is granted in ploy/license.txt.

import Dispatch


extension File {
  func createDispatchSource(modes: DispatchFileModes, queue: DispatchQueue = dispatchMainQueue,
    registerFn: Action? = nil, cancelFn: Action? = nil, eventFn: Action) -> DispatchSource {
      let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, _dispatchSourceHandle, modes.rawValue, queue)!
      if let rf = registerFn {
        dispatch_source_set_registration_handler(source, rf)
      }
      // the cancel handler retains the file to prevent a race condition
      // where the file descriptor gets reused but the source is not yet canceled.
      // see the documentation for dispatch_source_set_cancel_handler.
      let _self = self
      if let cf = cancelFn {
        dispatch_source_set_cancel_handler(source) {
          [_self] in
          _self // no-op.
          cf()
        }
      } else {
        dispatch_source_set_cancel_handler(source) {
          [_self] in
          _self
        }
      }
      dispatch_source_set_event_handler(source, eventFn)
      return source
  }
}