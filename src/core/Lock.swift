// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


func syncAction(obj: AnyObject, action : Action) {
  objc_sync_enter(obj)
  action()
  objc_sync_exit(obj)
}


func syncAround<T>(obj: AnyObject, body: () -> T) -> T {
  objc_sync_enter(obj)
  let result = body()
  objc_sync_exit(obj)
  return result
}



