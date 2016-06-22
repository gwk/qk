// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSOutputStream: OutputStream {
  
  public func write(_ string: String) {
    string.asUtf8() {
      (ptr, len) -> () in
      if len > 0 {
        let written = self.write(ptr, maxLength: len)
        // TODO: real error handling.
        assert(len == written, "\(len) != \(written); error: \(self.streamError)")
      }
      return ()
    }
  }

  func writeLn(_ string: String) {
    write(string)
    write("\n")
  }

  func writeLines(_ strings: String...) {
    for s in strings {
      writeLn(s)
    }
  }
}


func streamTo(_ path: String, append: Bool = false) -> NSOutputStream? {
  if let url = path.fileUrl {
    if let s = NSOutputStream(url: url, append: append) {
      s.open()
      return s
    }
  }
  return nil
}

