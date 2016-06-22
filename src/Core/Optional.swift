// © 2014 George King. Permission to use this file is granted in license-qk.txt.


extension Optional {

  @warn_unused_result
  func or(_ alt: @autoclosure () throws -> Wrapped) rethrows -> Wrapped {
    if let val = self {
      return val
    } else {
      return try alt()
    }
  }
}
