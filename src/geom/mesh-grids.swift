// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


func gridCage(divisions: Int) -> Mesh {
  let m = Mesh()
  let steps = divisions + 1
  for i in 0...steps {
    let t: Flt = Flt(Flt(i).native / Flt(steps).native) // hack around swiftc 1.1 typecheck bug.
    m.p.append(V3(t, t, t))
    
  }
  return m
}
