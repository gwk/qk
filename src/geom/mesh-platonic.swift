// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation
import SceneKit


extension Mesh {

  class func tetrahedron() -> Mesh {
    let r: Flt = sqrt(1.0 / 3.0); // radius of insphere.
    let m = Mesh(name: "tetrahedron")
    m.positions = [
      V3(-r, -r, -r), // cube 0.
      V3(-r,  r,  r), // cube 3.
      V3( r, -r,  r), // cube 5.
      V3( r,  r, -r), // cube 6.
    ]
    m.triangles = [
      Tri(0, 1, 3),
      Tri(0, 2, 1),
      Tri(0, 3, 2),
      Tri(1, 2, 3),
    ]
    m.adjacencies = [
      Adj(0, 1),
      Adj(0, 2),
      Adj(0, 3),
      Adj(1, 2),
      Adj(1, 3),
      Adj(2, 3),
    ]
    return m
  }

  class func cube() -> Mesh {
    let r: Flt = sqrt(1.0 / 3.0); // radius of insphere.
    let m = Mesh(name: "cube")
    m.positions = [
      V3(-r, -r, -r),
      V3(-r, -r,  r),
      V3(-r,  r, -r),
      V3(-r,  r,  r),
      V3(+r, -r, -r),
      V3(+r, -r,  r),
      V3(+r,  r, -r),
      V3(+r,  r,  r),
    ]
    m.segments = [
      Seg(0, 1),
      Seg(0, 2),
      Seg(0, 4),
      Seg(1, 3),
      Seg(1, 5),
      Seg(2, 3),
      Seg(2, 6),
      Seg(3, 7),
      Seg(4, 5),
      Seg(4, 6),
      Seg(5, 7),
      Seg(6, 7),
    ]
    m.triangles = [
      Tri(0, 1, 3),
      Tri(0, 2, 6),
      Tri(0, 3, 2),
      Tri(0, 4, 5),
      Tri(0, 5, 1),
      Tri(0, 6, 4),
      Tri(1, 5, 7),
      Tri(1, 7, 3),
      Tri(2, 3, 7),
      Tri(2, 7, 6),
      Tri(4, 6, 7),
      Tri(4, 7, 5),
    ]
    return m
  }

  class func octahedron() -> Mesh {
    let m = Mesh(name: "octahedron")
    m.positions = [
      V3(-1, -0,  0),
      V3( 0, -1,  0),
      V3( 0,  0, -1),
      V3( 0,  0,  1),
      V3( 0,  1,  0),
      V3( 1,  0,  0),
    ]
    m.triangles = [
      Tri(0, 1, 3),
      Tri(0, 2, 1),
      Tri(0, 3, 4),
      Tri(0, 4, 2),
      Tri(1, 2, 5),
      Tri(1, 5, 3),
      Tri(2, 4, 5),
      Tri(3, 5, 4),
    ]
    m.adjacencies = [
      Adj(0, 1),
      Adj(0, 2),
      Adj(0, 5),
      Adj(1, 3),
      Adj(1, 4),
      Adj(2, 3),
      Adj(2, 7),
      Adj(3, 6),
      Adj(4, 5),
      Adj(4, 6),
      Adj(5, 7),
      Adj(6, 7),
    ]
    return m
  }

  class func dodecahedron() -> Mesh {
    let r: Flt = sqrt(1.0 / 3.0) // radius of cube insphere.
    let phi: Flt = (1 + sqrt(5)) * 0.5 // golden ratio.
    // two types of vertices: cubic and axis-aligned rect.
    // rect major and minor are (phi, 1 / phi) for unit cube; must normalize by x.
    let m: Flt = r * phi // major.
    let n: Flt = r / phi // minor.
    let mesh = Mesh(name: "dodecahedron")
    mesh.positions = [
      V3(-m, -n,  0),
      V3(-m,  n,  0),
      V3(-r, -r, -r),
      V3(-r, -r,  r),
      V3(-r,  r, -r),
      V3(-r,  r,  r),
      V3(-n,  0, -m),
      V3(-n,  0,  m),
      V3(+0, -m, -n),
      V3(+0, -m,  n),
      V3(+0,  m, -n),
      V3(+0,  m , n),
      V3(+n,  0, -m),
      V3(+n,  0,  m),
      V3(+r, -r, -r),
      V3(+r, -r,  r),
      V3(+r,  r, -r),
      V3(+r,  r,  r),
      V3(+m, -n,  0),
      V3(+m,  n,  0),
    ]
    mesh.segments = [
      Seg(0, 1),
      Seg(0, 2),
      Seg(0, 3),
      Seg(1, 4),
      Seg(1, 5),
      Seg(2, 6),
      Seg(2, 8),
      Seg(3, 7),
      Seg(3, 9),
      Seg(4, 6),
      Seg(4, 10),
      Seg(5, 7),
      Seg(5, 11),
      Seg(6, 12),
      Seg(7, 13),
      Seg(8, 9),
      Seg(8, 14),
      Seg(9, 15),
      Seg(10, 11),
      Seg(10, 16),
      Seg(11, 17),
      Seg(12, 14),
      Seg(12, 16),
      Seg(13, 15),
      Seg(13, 17),
      Seg(14, 18),
      Seg(15, 18),
      Seg(16, 19),
      Seg(17, 19),
      Seg(18, 19),
    ]
    mesh.triangles = [
      Tri(0, 1, 4),
      Tri(0, 2, 8),
      Tri(0, 3, 7),
      Tri(0, 4, 6),
      Tri(0, 5, 1),
      Tri(0, 6, 2),
      Tri(0, 7, 5),
      Tri(0, 8, 9),
      Tri(0, 9, 3),
      Tri(1, 5, 11),
      Tri(1, 10, 4),
      Tri(1, 11, 10),
      Tri(2, 6, 12),
      Tri(2, 12, 14),
      Tri(2, 14, 8),
      Tri(3, 9, 15),
      Tri(3, 13, 7),
      Tri(3, 15, 13),
      Tri(4, 10, 16),
      Tri(4, 12, 6),
      Tri(4, 16, 12),
      Tri(5, 7, 13),
      Tri(5, 13, 17),
      Tri(5, 17, 11),
      Tri(8, 14, 18),
      Tri(8, 15, 9),
      Tri(8, 18, 15),
      Tri(10, 11, 17),
      Tri(10, 17, 19),
      Tri(10, 19, 16),
      Tri(12, 16, 19),
      Tri(12, 18, 14),
      Tri(12, 19, 18),
      Tri(13, 15, 18),
      Tri(13, 18, 19),
      Tri(13, 19, 17),
    ]
    return mesh
  }

  class func icosahedron() -> Mesh {
    let phi: Flt = (1 + sqrt(5)) * 0.5 // golden ratio.
    // each vertex is also the vertex of an axis-aligned golden rectangle.
    // compute the radius and normalize major and minor lengths.
    let r: Flt = sqrt(phi * phi + 1)
    let m: Flt = phi / r // major.
    let n: Flt = 1.0 / r // minor.
    let mesh = Mesh(name: "icosahedron")
    mesh.positions = [
      V3(-m, -n,  0), // south.
      V3(-m,  n,  0), // southwest.
      V3(-n,  0, -m),
      V3(-n,  0,  m),
      V3(+0, -m, -n),
      V3(+0, -m,  n),
      V3(+0,  m, -n), // northern hemisphere.
      V3(+0,  m,  n),
      V3(+n,  0, -m),
      V3(+n,  0, +m),
      V3(+m, -n,  0), // northeast.
      V3(+m,  n,  0), // north.
    ]
    mesh.triangles = [
      Tri(0, 1, 2),
      Tri(0, 2, 4),
      Tri(0, 3, 1),
      Tri(0, 4, 5),
      Tri(0, 5, 3),
      Tri(1, 3, 7),
      Tri(1, 6, 2),
      Tri(1, 7, 6),
      Tri(2, 6, 8),
      Tri(2, 8, 4),
      Tri(3, 5, 9), // index 10.
      Tri(3, 9, 7),
      Tri(4, 8, 10),
      Tri(4, 10, 5),
      Tri(5, 10, 9),
      Tri(6, 7, 11),
      Tri(6, 11, 8),
      Tri(7, 9, 11),
      Tri(8, 11, 10),
      Tri(9, 10, 11),
    ]
    mesh.adjacencies = [
      Adj(0, 1),
      Adj(0, 2),
      Adj(0, 6),
      Adj(1, 3),
      Adj(1, 9),
      Adj(2, 4),
      Adj(2, 5),
      Adj(3, 4),
      Adj(3, 13),
      Adj(4, 10),
      Adj(5, 7),
      Adj(5, 11),
      Adj(6, 7),
      Adj(6, 8),
      Adj(7, 15),
      Adj(8, 9),
      Adj(8, 16),
      Adj(9, 12),
      Adj(10, 11),
      Adj(10, 14),
      Adj(11, 17),
      Adj(12, 13),
      Adj(12, 18),
      Adj(13, 14),
      Adj(14, 19),
      Adj(15, 16),
      Adj(15, 17),
      Adj(16, 18),
      Adj(17, 19),
      Adj(18, 19),
    ]
    return mesh
  }
}
