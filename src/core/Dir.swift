// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Darwin


class Dir {

  typealias Descriptor = UnsafeMutablePointer<Darwin.DIR>

  enum Error: ErrorType {
    case Path(String)
  }

  let path: String
  private let descriptor: Descriptor

  init(_ path: String) throws {
    self.path = path
    self.descriptor = opendir(path)
    guard descriptor != nil else {
      throw Error.Path(path)
    }
  }

  func listNames(prefix prefix: String? = nil, suffix: String? = nil, includeHidden: Bool = false) -> [String] {
    var names = [String]()
    while true {
      let entryPtr = Darwin.readdir(descriptor)
      if entryPtr == nil {
        break
      }
      var name = ""
      withUnsafePointer(&entryPtr.memory.d_name) {
        name = String.fromCString(UnsafePointer<Int8>($0))!
      }
      if !includeHidden {
        if name.hasPrefix(".") { continue }
      }
      else if [".", ".."].contains(name) { continue }
      if let prefix = prefix {
        if !name.hasPrefix(prefix) { continue }
      }
      if let suffix = suffix {
        if !name.hasSuffix(suffix) { continue }
      }
      names.append(name)
    }
    return names
  }

  func listPaths(prefix prefix: String? = nil, suffix: String? = nil) -> [String] {
    return listNames(prefix: prefix, suffix: suffix).map() { "\(path)/\($0)" }
  }
}

