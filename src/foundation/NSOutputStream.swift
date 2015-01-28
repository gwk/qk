// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSOutputStream: OutputStreamType {
  
  public func write(string: String) {
    string.nulTerminatedUTF8.withUnsafeBufferPointer() {
      (p) -> () in
      let count = p.count - 1 // exclude null terminator.
      if count > 0 {
        let countWritten = self.write(p.baseAddress, maxLength: count)
        // TODO: real error handling.
        assert(count == countWritten, "\(count) != \(countWritten); error: \(self.streamError)")
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

