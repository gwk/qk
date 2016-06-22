// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Dispatch


let dispatchMainQueue: DispatchQueue = DispatchQueue.main


// MARK: async

func async(_ queue: DispatchQueue = dispatchMainQueue, action: Action) {
  queue.async(execute: action)
}


func async_after(_ delay: Time, queue: DispatchQueue = dispatchMainQueue, action: Action) {
  let nanoseconds = delay * 1000000000
  queue.after(when: DispatchTime.now() + Double(I64(nanoseconds)) / Double(NSEC_PER_SEC), execute: action)
}

// MARK: sync

func sync(_ queue: DispatchQueue = dispatchMainQueue, action: Action) {
  queue.sync(execute: action);
}


// MARK: printing

func outLLA(_ items: [String]) {
  async() {
    for i in items {
      print(i)
    }
  }
}

func outLLA(_ items: String...) { outLLA(items) }
