// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


func assertMainThread() {
  assert(Thread.isMainThread())
}

func assertChildThread() {
  assert(!Thread.isMainThread())
}

extension Foundation.Thread {}
