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

struct Zip2<G0: GeneratorType, G1: GeneratorType> {
  var g0: G0
  var g1: G1
  
  mutating func next() -> (G0.Element, G1.Element)? {
    if let e0 = g0.next() {
      if let e1 = g1.next() {
        return (e0, e1)
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
}

func zip<G0: GeneratorType, G1: GeneratorType>(g0: G0, g1: G1) -> Zip2<G0, G1> {
  return Zip2(g0: g0, g1: g1)
}


  