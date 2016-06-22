// © 2015 George King. Permission to use this file is granted in license-qk.txt.


enum Result<T, U> {
  case ok(T)
  case alt(U)
}
