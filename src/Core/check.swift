// © 2014 George King. Permission to use this file is granted in license-qk.txt.


func check(_ condition: Bool, _ message: @autoclosure () -> String) {
  if !condition {
    fail(message())
  }
}

func check(_ condition: Bool, file: StaticString = #file, line: UInt = #line) {
  if !condition {
    fatalError("check failure", file: file, line: line)
  }
}

@noreturn func fail(_ message: String) {
  std_err.write("error: ")
  std_err.write(message)
  std_err.write("\n")
  Process.exit(1)
}

@noreturn func fail(error: ErrorProtocol) {
  std_err.write("error: ")
  std_err.write(String(error))
  std_err.write("\n")
  Process.exit(1)
}

func guarded<R>(label: String = "error: ", _ fn: @noescape () throws -> R) -> R {
  do {
    return try fn()
  } catch let e {
    std_err.write(label)
    std_err.write(String(e))
    std_err.write("\n")
    Process.exit(1)
  }
}
