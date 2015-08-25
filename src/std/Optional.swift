// © 2014 George King. Permission to use this file is granted in license-qk.txt.


extension Optional {

  func or(@autoclosure alt: () -> Wrapped) -> Wrapped {
    if let val = self {
      return val
    } else {
      return alt()
    }
  }
}
