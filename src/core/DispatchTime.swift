// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


typealias DispatchTime = dispatch_time_t

extension DispatchTime {

  static var now: DispatchTime = DISPATCH_TIME_NOW
  static var forever: DispatchTime = DISPATCH_TIME_FOREVER

  static func fromNow(seconds: Double) -> DispatchTime {
    return dispatch_time(now, Int64(seconds * 1e9))
  }
}