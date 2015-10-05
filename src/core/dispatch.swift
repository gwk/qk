// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


typealias DispatchQueue = dispatch_queue_t

let dispatchMainQueue: DispatchQueue = dispatch_get_main_queue()


// MARK: async

func async(action: Action) {
  dispatch_async(dispatchMainQueue, action)
}

func async(queue: DispatchQueue, action: Action) {
  dispatch_async(queue, action)
}

func async(qos: DispatchQOS, action: Action) {
  dispatch_async(qos.queue, action)
}


// MARK: sync

func sync(action: Action) {
  dispatch_sync(dispatchMainQueue, action);
}


// MARK: printing

func outLLA(items: [String]) {
  async() {
    for i in items {
      print(i)
    }
  }
}

func outLLA(items: String...) { outLLA(items) }
