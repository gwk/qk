// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSOutputStream: OutputStreamType {
  
  public func write(string: String) {
    string.nulTerminatedUTF8.withUnsafeBufferPointer() {
      (p) in
      self.write(p.baseAddress, maxLength: p.count - 1)
    }
  }
}


func streamOut(path: String, append: Bool = false) -> NSOutputStream? {
  if let url = path.fileUrl {
    if let s = NSOutputStream(URL: url, append: append) {
      s.open()
      return s
    }
  }
  return nil
}

