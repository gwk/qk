// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation
import SceneKit


func tri() -> Mesh {
  let r: F32 = sqrt(1.0 / 3.0) // radius of insphere.
  let m = Mesh()
  m.p = [
    V3(-r, -r, -r),
    V3(-r,  r,  r),
    V3( r,  r, -r),
  ]
  m.seg = [
    Seg(0, 1),
    Seg(0, 2),
    Seg(1, 2),
  ]
  m.tri = [
    Tri(0, 1, 2),
    Tri(0, 2, 1),
  ]
  return m;
}


func tetrahedron() -> Mesh {
  let r: F32 = sqrt(1.0 / 3.0); // radius of insphere.
  let m = Mesh()
  m.p = [
    V3(-r, -r, -r), // cube 0.
    V3(-r,  r,  r), // cube 3.
    V3( r, -r,  r), // cube 5.
    V3( r,  r, -r), // cube 6.
  ]
  m.n = m.p
  for i in 0..<m.p.count {
    m.c.append(V4F32(m.p[i], 1))
  }
  m.tri = [
    Tri(0, 1, 3),
    Tri(0, 2, 1),
    Tri(0, 3, 2),
    Tri(1, 2, 3),
  ]
  m.adj = [
    Adj(0, 1),
    Adj(0, 2),
    Adj(0, 3),
    Adj(1, 2),
    Adj(1, 3),
    Adj(2, 3),
  ]
  println(m.p)
  return m
}

