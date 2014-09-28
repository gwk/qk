// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation
import SceneKit


func tri() -> Mesh {
  let ri: F32 = sqrt(1.0 / 3.0) // radius of insphere.
  let v = [
      V3(-ri, -ri, -ri),
      V3(-ri,  ri,  ri),
      V3( ri,  ri, -ri),
    ]
  let e = [
  Seg(0, 1),
  Seg(0, 2),
  Seg(1, 2),
  ]
  let t = [
    Tri(0, 1, 2),
    Tri(0, 2, 1),
  ]
  let a: [Adj] = []
  return Mesh(v:v, e:e, t:t)
}

