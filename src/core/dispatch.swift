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


// MARK: async

func async(action: Action) {
  dispatch_async(dispatch_get_main_queue(), action)
}

func async(queue: dispatch_queue_t, action: Action) {
  dispatch_async(queue, action)
}

func async(qos: DispatchQOS, action: Action) {
  dispatch_async(qos.queue, action)
}


// MARK: sync

func sync(action: Action) {
  dispatch_sync(dispatch_get_main_queue(), action);
}


// MARK: printing

func outLLA(items: [String]) {
  dispatch_async(dispatch_get_main_queue()) {
    for i in items {
      print(i)
    }
  }
}

func outLLA(items: String...) { outLLA(items) }
