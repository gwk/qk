// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


typealias Time = F64

func sysTime() -> Time {
  return NSProcessInfo.processInfo().systemUptime
}

// note: this is lazily evaluated, so it must be accessed at launch time to initialize accurately.
let appLaunchSysTime: Time = sysTime()

func initAppLaunchSysTime() -> Time {
  return appLaunchSysTime
}

func appTime() -> Time {
  return sysTime() - appLaunchSysTime
}
