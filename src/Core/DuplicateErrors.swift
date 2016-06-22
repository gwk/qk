// © 2014 George King. Permission to use this file is granted in license-qk.txt.


struct DuplicateElError<T>: ErrorProtocol {
  let el: T
}


struct DuplicateKeyError<K, V>: ErrorProtocol {
  let key: K
  let existing: V
  let incoming: V
}
