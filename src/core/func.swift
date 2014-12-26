// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


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
  for (i, e) in enumerate(seq) {
    let (k, v) = transform(i, e)
    d[k] = v
  }
  return d
}


func take<G: GeneratorType>(var gen: G, var n: Int) -> [G.Element] {
  var a: [G.Element] = []
  while n > 0 {
    let oe = gen.next()
    if let e = oe {
      a.append(e)
    } else {
      return a
    }
    n--
  }
  return a
}


func takeWhile<G: GeneratorType>(var gen: G, pred: (G.Element) -> Bool) -> [G.Element] {
  // NOTE: the element that fails the predicate is necessarily discarded; there is no way to 'put back' into the generator.
  var a: [G.Element] = []
  while true {
    let oe = gen.next()
    if let e = oe {
      if !pred(e) {
        return a
      } else {
        a.append(e)
      }
    } else {
      return a
    }
  }
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


  