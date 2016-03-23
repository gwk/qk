// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


enum DispatchQOS {
  case UserInteractive
  case UserInitiated
  case Default
  case Utility
  case Background

  var rawValue: dispatch_qos_class_t {
    switch self {
    case UserInteractive: return QOS_CLASS_USER_INTERACTIVE
    case UserInitiated:   return QOS_CLASS_USER_INITIATED
    case Default:         return QOS_CLASS_DEFAULT
    case Utility:         return QOS_CLASS_UTILITY
    case Background:      return QOS_CLASS_BACKGROUND
    }
  }

  var queue: dispatch_queue_t {
    return dispatch_get_global_queue(rawValue, 0)
  }
}


