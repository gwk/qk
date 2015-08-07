// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


func check(condition: Bool, @autoclosure _ message: () -> String, file: StaticString = __FILE__, line: UInt = __LINE__) {
  if !condition {
    fatalError(message, file: file, line: line)
  }
}