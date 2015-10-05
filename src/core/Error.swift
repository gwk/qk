// © 2015 George King. Permission to use this file is granted in license-qk.txt.


func stringForCurrentError() -> String {
  return String.fromCString(strerror(errno))!
}

func checkError(error: ErrorType?) {
  if let error = error {
    fail("error: \(error)")
  }
}
