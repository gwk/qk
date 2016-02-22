// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


typealias DispatchQueue = dispatch_queue_t

let dispatchMainQueue: DispatchQueue = dispatch_get_main_queue()


// MARK: async

func async(queue: DispatchQueue = dispatchMainQueue, action: Action) {
  dispatch_async(queue, action)
}

func async(qos: DispatchQOS, action: Action) {
  dispatch_async(qos.queue, action)
}

func async_after(delay: Time, queue: DispatchQueue = dispatchMainQueue, action: Action) {
  let nanoseconds = delay * 1000000000
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, I64(nanoseconds)), queue, action)
}

// MARK: sync

func sync(queue: DispatchQueue = dispatchMainQueue, action: Action) {
  dispatch_sync(queue, action);
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
