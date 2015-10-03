// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol Reloadable {
  mutating func reload(file:File) -> Bool
}


let resourceRootDir: String = {
  // TODO: if in release mode or flag not present, return bundle resource directory.
  return Process.environment["RALLY_RES"]!
}()


func pathForResourcePath(resPath: String) -> String {
  return "\(resourceRootDir)/\(resPath)"
}


class Resource<T: Reloadable> {
  // A Resource is an encapsulated object:T that can be reloaded from a file asset.
  // When the file changes the Resource calls reload to update the object.
  // It is intended as a mechanism for speeding up the development cycle.
  // Hot loading requires some sort of mutation of the object.
  
  static var queue: dispatch_queue_t { return dispatch_get_main_queue() } // dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0) }
  
  static func createSource(file: File) -> dispatch_source_t {
    return dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, UInt(file.fd), DispatchFileModes.loadable.rawValue, Resource.queue)
  }
  
  let resPath: String
  let path: String
  var file: InFile
  var obj: T
  var source: dispatch_source_t!
  
  deinit {
    dispatch_source_cancel(self.source)
  }
  
  init(resPath: String, obj: T) {
    let path = pathForResourcePath(resPath)
    self.resPath = resPath
    self.path = path
    self.file = InFile(path: path)
    self.obj = obj
    self.source = nil // set by enqueue.
    self.enqueue()
  }
  
  func enqueue() {
    
    let eventFn: Action = {
      let m = dispatch_source_get_data(self.source)
      let mode = DispatchFileModes(rawValue: m)
      if (mode == .Delete || mode == .Revoke) {
        print("watched file deleted/revoked: \(self.resPath)")
        dispatch_source_cancel(self.source)
      } else {
        lseek(self.file.fd, 0, SEEK_SET) // TODO: necessary?
        self.obj.reload(self.file)
      }
    }
    
    let cancelFn: Action = {
      [weak self] () -> () in
      print("watched file source canceled: \(self?.resPath)")
      if let s = self {
        close(s.file.fd) // TODO: still necessary with InFile object semantics?
      }
      while true {
        if let s = self {
          let fd = open(s.path, O_RDONLY)
          if fd != -1 {
            print("watched file reopened: \(s.resPath)")
            s.file = InFile(fd: fd, desc: s.file.description)
            s.obj.reload(s.file) // is this redundant with eventFn???
            s.enqueue()
          }
        } else { // self was deallocated.
          break
        }
        sleep(1)
      }
    }
    
    self.source = Resource.createSource(file)
    dispatch_source_set_event_handler(source, eventFn)
    dispatch_source_set_cancel_handler(source, cancelFn)
    dispatch_resume(source)
  }
}

