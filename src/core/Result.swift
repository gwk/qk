// © 2015 George King. Permission to use this file is granted in license-qk.txt.


enum Result<T, U> {
  case Ok(T)
  case Alt(U)
}
