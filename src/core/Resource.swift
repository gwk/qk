// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


typealias File = CInt // file descriptor.

class Resource<T> {
  // A Resource is an encapsulated object:T that can be hotloaded from a file asset.
  // When the file changes the Resource calls a reload function to update or replace the object.
  // It is intended as a mechanism for speeding up the development cycle.
  // Hot loading requires some sort of mutation of the working object graph; otherwise it will have on effect.
  // Resource supports both mutable and immutable objects;
  // Resources of immutables function by mutating themselves on update.
  
  // either init or reload the object.
  typealias LoadFn = (file: File, update: (T, DispatchFileModes)?) -> T

  static var queue: dispatch_queue_t { return dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0) }
  
  static func createSource(file: File) -> dispatch_queue_t {
    return dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, UInt(file), DispatchFileModes.all.rawValue, Resource.queue)
  }
  
  static var rootDir: String {
    // TODO: if in release mode or flag not present, return bundle resource directory.
    return Process.environment["RALLY_RES"]!
  }
  
  let path: String
  var file: File
  var obj: T
  let loadFn: LoadFn
  var source: dispatch_source_t!
  
  deinit {
    close(file)
  }
  
  init(relPath: String, loadFn: LoadFn) {
    let path = "\(Resource.rootDir)/\(relPath)"
    self.path = path
    self.file = open(path, O_RDONLY)
    // TODO: make this a failable init.
    check(file >= 0, "resource path does not exist: \(path)")
    self.loadFn = loadFn
    self.obj = loadFn(file: file, update: nil)
    //let modes = DispatchFileModes.all
    self.source = nil // set by enqueue.
    self.enqueue()
  }
  
  func enqueue() {
    
    let eventFn: Action = {
      let m = dispatch_source_get_data(self.source)
      let update = (self.obj, DispatchFileModes(rawValue: m))
      self.obj = self.loadFn(file: self.file, update: update)
      if (m & DISPATCH_VNODE_DELETE != 0) {
        print("watched file deleted! canceling source")
        dispatch_source_cancel(self.source)
      }
    }
    
    let cancelFn: Action = {
      close(self.file)
      while true {
        let file = open(self.path, O_RDONLY)
        if file != -1 {
          self.file = file
          break
        }
        sleep(1)
      }
      self.enqueue()
    }
    
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, UInt(file), DispatchFileModes.all.rawValue, Resource.queue)
    dispatch_source_set_event_handler(source, eventFn)
    dispatch_source_set_cancel_handler(source, cancelFn)
    dispatch_resume(source)
  }
}

