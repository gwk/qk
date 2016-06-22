// © 2015 George King. All rights reserved.

import AppKit

print("appLaunchSysTime: \(appLaunchSysTime)") // force evaluation of the lazy global to correctly set the time.

let app = NSApplication.shared()
let appDelegate = AppDelegate() // bound to global because app.delegate is unowned.
app.delegate = appDelegate
app.setActivationPolicy(NSApplicationActivationPolicy.regular)
app.run()
