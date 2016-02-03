// © 2015 George King. All rights reserved.

import AppKit


print("appLaunchSysTime: \(appLaunchSysTime)") // force evaluation of the lazy global to correctly set the time.
let app = NSApplication.sharedApplication()
let appDelegate = AppDelegate() // bound to global because app.delegate is unowned.
let appRandom = Random()
app.setActivationPolicy(NSApplicationActivationPolicy.Regular)
app.delegate = appDelegate
app.run()
