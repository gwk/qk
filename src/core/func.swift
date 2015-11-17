// © 2014 George King. Permission to use this file is granted in license-qk.txt.


typealias Action = () -> ()
typealias Predicate = () -> Bool


let always: Predicate = { return true }
let never: Predicate = { return false }
