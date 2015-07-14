// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


typealias Action = () -> ()
typealias Predicate = () -> Bool


let always: Predicate = { return true }
let never: Predicate = { return false }


func mapToDict<S: SequenceType, K, V>(seq: S, transform: (S.Generator.Element) -> (K, V)) -> [K:V] {
  var d = [K:V]()
  for e in seq {
    let (k, v) = transform(e)
    d[k] = v
  }
  return d
}

func mapEnumToDict<S: SequenceType, K, V>(seq: S, transform: (Int, S.Generator.Element) -> (K, V)) -> [K:V] {
  var d = [K:V]()
  for (i, e) in seq.enumerate() {
    let (k, v) = transform(i, e)
    d[k] = v
  }
  return d
}

func filterMap<S: SequenceType, E>(seq: S, transform: ((S.Generator.Element) -> E?)) -> [E] {
  var a: [E] = []
  for e in seq {
    if let t = transform(e) {
      a.append(t)
    }
  }
  return a
}

  