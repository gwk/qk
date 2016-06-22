// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


typealias Time = F64

extension Time {
 static var distantFuture: Time {
    return 1e300
  }
}


@warn_unused_result
func sysTime() -> Time {
  return ProcessInfo.processInfo().systemUptime
}

// note: this is lazily evaluated, so it must be accessed at launch time to initialize accurately.
// TODO: remove and just use sysTime instead?
let appLaunchSysTime: Time = sysTime()

func initAppLaunchSysTime() -> Time {
  return appLaunchSysTime
}

@warn_unused_result
func appTime() -> Time {
  return sysTime() - appLaunchSysTime
}
