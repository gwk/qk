// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


func assertMainThread() {
  assert(NSThread.isMainThread())
}


extension NSThread {}
