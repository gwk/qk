// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


extension Optional {

  func alt(alt: @autoclosure () -> T) -> T {
    if let val = self {
      return val
    } else {
      return alt()
    }
  }
}