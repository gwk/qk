// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Darwin


@warn_unused_result
func stringForCurrentError() -> String {
  return String(cString: strerror(errno))
}

func checkError(_ error: ErrorProtocol?) {
  if let error = error {
    fail("error: \(error)")
  }
}
