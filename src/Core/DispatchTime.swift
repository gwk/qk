// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


extension DispatchTime {

  @warn_unused_result
  static func fromNow(_ seconds: Double) -> DispatchTime {
    return now() + seconds
  }
}
