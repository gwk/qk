// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSOutputStream: OutputStreamType {
  
  public func write(string: String) {
    string.withUtf8() {
      (ptr, len) -> () in
      if len > 0 {
        let written = self.write(ptr, maxLength: len)
        // TODO: real error handling.
        assert(len == written, "\(len) != \(written); error: \(self.streamError)")
      }
      return ()
    }
  }

  func writeLn(string: String) {
    write(string)
    write("\n")
  }

  func writeLines(strings: String...) {
    for s in strings {
      writeLn(s)
    }
  }
}


func streamTo(path: String, append: Bool = false) -> NSOutputStream? {
  if let url = path.fileUrl {
    if let s = NSOutputStream(URL: url, append: append) {
      s.open()
      return s
    }
  }
  return nil
}

