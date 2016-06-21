// © 2014 George King. Permission to use this file is granted in license-qk.txt.


struct DuplicateElError<T>: ErrorType {
  let el: T
}


struct DuplicateKeyError<K, V>: ErrorType {
  let key: K
  let existing: V
  let incoming: V
}
