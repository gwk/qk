// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


protocol Reloadable {
  init()
  mutating func reload(file: InFile) -> Bool
}


let resourceRootDir: String = {
  // TODO: if in release mode or flag not present, return bundle resource directory.
  let key = "RALLY_RESOURCE_DIR"
  if let path = Process.environment[key] {
    errL("resourceRootDir: using \(key): \(path)")
    return path
  }
  return NSBundle.mainBundle().pathForResource("res", ofType: nil)!
}()


@warn_unused_result
func pathForResource(resPath: String) -> String {
  return "\(resourceRootDir)/\(resPath)"
}


class Resource<T: Reloadable> {
  // A Resource is an encapsulated object that can be reloaded from a file asset.
  // When the file changes the Resource calls reload to update the object.
  // It is intended as a means of speeding up the development cycle.
  // Note that this mechanism requires some sort of mutation of the object.
  
  let resPath: String
  let path: String
  private(set) var obj: T
  private var file: InFile? = nil
  private var source: DispatchSource? = nil
  
  deinit {
    cancelSource()
  }
  
  init(resPath: String) {
    let path = pathForResource(resPath)
    self.resPath = resPath
    self.path = path
    self.obj = T()
    retry()
  }

  func cancelSource() {
    source?.cancel()
    source = nil
  }

  func reload() {
    if !self.obj.reload(self.file!) {
      errL("resource reload failed: \(self.resPath)")
    }
  }

  func retry() {
    do {
      file = try InFile(path: path)
      errL("resource file opened: \(resPath)")
      reload()
      enqueue()
    } catch let e {
      errL("resource file unavailable: \(resPath); error: \(e)")
      dispatch_after(DispatchTime.fromNow(1), dispatchMainQueue) {
        [weak self] in
        self?.retry()
      }
    }
  }

  func handleEvent() {
    let m = source!.getData() as dispatch_source_vnode_flags_t
    let modes = DispatchFileModes(rawValue: m)
    if modes.contains(.Delete) || modes.contains(.Rename) || modes.contains(.Revoke) {
      errL("resource removed (\(modes)): \(resPath)")
      cancelSource()
      return
    }
    assert(modes == .Write, "unexpected modes: \(modes)")
    errL("resource modified: \(resPath)")
    if !file!.rewindMaybe() {
      errL("resource rewind failed: \(resPath)")
      cancelSource()
      return
    }
    reload()
  }

  func handleCancel() {
    errL("resource dispatch source canceled: \(resPath)")
    file = nil
    retry()
  }

  func enqueue() {
    let cancelFn: Action = { [weak self] in self?.handleCancel() }
    let eventFn: Action = { [weak self] in self?.handleEvent() }
    source = file!.createDispatchSource([.Delete, .Rename, .Revoke, .Write], cancelFn: cancelFn, eventFn: eventFn)
    source!.resume()
  }
}

