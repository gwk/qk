// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension Mesh {

  class func globe(texInfo texInfo: (triW: Flt, triH: Flt, vSpace: Flt)? = nil) -> Mesh {
    // returns a globe with vertex radius of 1.
    // the globe is essentially an icosahedron, but differs from Mesh.icosahedron as follows:
    // - globe has "polar" vertices that are positioned at the -y and +y axes.
    // - there are multiple polar vertices at each pole.
    // - for each ring of "tropical" vertices, there is a single duplicated vertex to allow correct texture wrapping.

    // the texture is split into northern and southern hemispheres,
    // and wraps vertically so that the equator is both the top and bottom edge;
    // the southern hemisphere is the top half.
    // the polar faces intermesh, and each half is given vSpace extra pixels vertically to prevent bleeding between them.
    // ______________________
    // |/__\/__\/__\/__\/__\| // southern tropics.
    // |\  /\  /\  /\  /\  /| // southern poles, with northern polar tips.
    // |_\/__\/__\/__\/__\/_| // northern poles, with southern polar tips.
    // |_/\__/\__/\__/\__/\_| // northern tropics.

    let phi: Flt = (1 + sqrt(5)) * 0.5 // golden ratio.
    // each icosahedron vertex is also the vertex of an axis-aligned golden rectangle.
    // compute the radius and normalize major and minor lengths.
    let r = sqrt(phi * phi + 1)
    let m = phi / r // major.
    let n = 1.0 / r // minor.
    // globe rotates this icosahedron around the z axis to place a polar vertices on the y axis.
    let t0ny = n / sqrt(1 + phi.sqr) // derived from: x.sqr + y.sqr = n.sqr; x/y = phi.
    let t0n = V2(-phi * t0ny, t0ny) // transformed (0, n).
    let tn0 = V2(t0ny, phi * t0ny) // transformed (n, 0).
    let tm0 = tn0 * phi
    let t0m = t0n * phi
    let mesh = Mesh(name: "globe")
    mesh.positions = [
      V3( 0, -1,  0), // south pole.
      V3( 0, -1,  0),
      V3( 0, -1,  0),
      V3( 0, -1,  0),
      V3( 0, -1,  0),
      V3(-tm0 + t0n, z:  0), // southwest.
      V3(-tn0,       z:  m),
      V3(      -t0m, z:  n),
      V3(      -t0m, z: -n),
      V3(-tn0,       z: -m),
      V3(-tm0 + t0n, z:  0), // southern duplicate.
      V3(       t0m, z:  n), // northern hemisphere.
      V3( tn0,       z:  m),
      V3( tm0 - t0n, z:  0), // northeast.
      V3( tn0,       z: -m),
      V3(       t0m, z: -n),
      V3(       t0m, z:  n), // northern duplicate.
      V3( 0,  1,  0),
      V3( 0,  1,  0),
      V3( 0,  1,  0),
      V3( 0,  1,  0),
      V3( 0,  1,  0),
    ]
    if let info = texInfo {
      // TODO: allow for placing vertices at pixel centers.
      let xp = 1 / (5 * info.triW) // TODO: account for pixel centering.
      let yp = 1 / ((info.triH + info.vSpace) * 2) // TODO: account for pixel centering.
      let w = xp * info.triW
      let h = yp * info.triH
      let t = h * 0.5 // the southern tropic y position; northern is negative.
      let p = h * 1.5 // the south pole y position; northern is negative.
      mesh.texture0s = [
        V2(w * 0.5,  p), // south pole.
        V2(w * 1.5,  p),
        V2(w * 2.5,  p),
        V2(w * 3.5,  p),
        V2(w * 4.5,  p),
        V2(w * 0.0,  t),
        V2(w * 1.0,  t),
        V2(w * 2.0,  t),
        V2(w * 3.0,  t),
        V2(w * 4.0,  t),
        V2(w * 5.0,  t), // southern duplicate.
        V2(w * 0.5, -t),
        V2(w * 1.5, -t),
        V2(w * 2.5, -t),
        V2(w * 3.5, -t),
        V2(w * 4.5, -t),
        V2(w * 5.5, -t), // northern duplicate.
        V2(w * 1.0, -p), // north pole.
        V2(w * 2.0, -p),
        V2(w * 3.0, -p),
        V2(w * 4.0, -p),
        V2(w * 5.0, -p),
      ]
    }
    mesh.addNormalsFromOriginToPositions()
    for i in 0..<5 { // do all of the pole edges manually, since there are multiple poles.
      let j = i + 1
      let sp = i
      let st0 = 5 + i
      let st1 = 5 + j
      let nt0 = 11 + i
      let nt1 = 11 + j
      let np = 17 + i
      mesh.segments.append(Seg(sp, st0)) // south polar face.
      mesh.segments.append(Seg(sp, st1))
      mesh.segments.append(Seg(st0, st1))
      mesh.segments.append(Seg(np, nt0)) // north polar face.
      mesh.segments.append(Seg(np, nt1))
      mesh.segments.append(Seg(nt0, nt1))
      mesh.segments.append(Seg(st0, nt0)) // tropic to tropic.
      mesh.segments.append(Seg(st1, nt0))
    }
    mesh.segments.append(Seg(10, 16))
    mesh.segments.sortInPlace()
    mesh.addTrianglesFromSegments()
    return mesh
  }

}
