// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import SceneKit


enum GeomKind {
  case point
  case seg
  case tri
}

class Mesh {
  var name: String? = nil
  var positions: [V3] = []
  var normals: [V3] = []
  var colors: [V4] = []
  var texture0s: [V2] = []
  #if false // TODO: implement creases.
  var vertexCreases: [F32] = []
  var edgeCreases: [F32] = []
  #endif
  #if false // TODO: implement BoneIndices.
  var boneWeights: [V4] = []
  var boneIndices: [BoneIndices] = []
  #endif

  var points: [Int] = []
  var segments: [Seg<Int>] = []
  var triangles: [Tri<Int>] = []
  var adjacencies: [Adj] = []

  init(name: String? = nil) {
    self.name = name
  }

  func printContents() {
    print("Mesh:")
    for (i, pos) in positions.enumerated() {
      print("  p[\(i)] = \(pos)")
    }
  }
  
  func addNormalsFromOriginToPositions() {
    assert(normals.isEmpty)
    for pos in positions {
      normals.append(pos.norm)
    }
  }
  
  func addColorsFromPositions() {
    assert(colors.isEmpty)
    for pos in positions {
      let color3 = (pos * 0.5 + 0.5).clampToUnit
      colors.append(V4(color3, w: 1))
    }
  }
  
  func addAllPoints() {
    for i in 0..<positions.count {
      points.append(i)
    }
  }
  
  func addAllSegments() {
    for i in 0..<positions.count {
      for j in (i + 1)..<positions.count {
        segments.append(Seg(i, j))
      }
    }
  }

  func addAllSegmentsLessThan(_ len: Flt) {
    for (i, a) in positions.enumerated() {
      for j in (i + 1)..<positions.count {
        let b = positions[j]
        let d = a.dist(b)
        if d > 0 && d < len {
          print(d, a, b)
          segments.append(Seg(i, j))
        }
      }
    }
  }

  func addTrianglesFromSegments() {
    for (i, s) in segments.enumerated() {
      for j in (i + 1)..<segments.count {
        let t = segments[j]
        assert(s.a < t.a || (s.a == t.a && s.b < t.b))
        for k in (j + 1)..<segments.count {
          let u = segments[k]
          assert(t.a < u.a || (t.a == u.a && t.b < u.b))
          if s.a == t.a && s.b == u.a && t.b == u.b {
            let a = s.a
            let b = s.b
            let c = t.b
            var tri = Tri(a, b, c)
            let va = positions[a]
            let vb = positions[b]
            let vc = positions[c]
            let center = (va + vb + vc) / 3
            let edge0 = vb - va
            let edge1 = vc - va
            let normal = edge0.cross(edge1)
            if center.dot(normal) < 0 {
              tri = tri.swizzled
            }
            triangles.append(tri)
          }
        }
      }
    }
  }

  func addSeg(_ a: V3, _ b: V3) {
    let i = positions.count
    positions.append(contentsOf: [a, b])
    segments.append(Seg(i, i + 1))
  }
  
  func addQuad(_ a: V3, _ b: V3, _ c: V3, _ d: V3) {
    let i = positions.count
    positions.append(contentsOf: [a, b, c, d])
    triangles.append(contentsOf: [Tri(i, i + 1, i + 2), Tri(i, i + 2, i + 3)])
  }
  
  func geometry(_ kind: GeomKind = .tri) -> SCNGeometry {
    
    let len = positions.count

    // data offsets.
    let op = 0 // position data is required.
    var on = 0
    var oc = 0
    var ot0 = 0
    #if false // TODO: creases.
      var ovc = 0
      var oec = 0
    #endif
    #if false // TODO: bones.
      var obw = 0
    var obi = 0
    #endif

    var stride = sizeof(V3S)
    if !normals.isEmpty {
      assert(normals.count == len)
      on = stride
      stride += sizeof(V3S)
    }
    if !colors.isEmpty {
      assert(colors.count == len)
      oc = stride
      stride += sizeof(V4S)
    }
    if !texture0s.isEmpty {
      assert(texture0s.count == len)
      ot0 = stride
      stride += sizeof(V2S)
    }
    #if false // TODO: creases.
    if !vertexCreases.isEmpty {
      assert(vertexCreases.count == len)
      ovc = stride
      stride += sizeof(F32)
    }
    if !edgeCreases.isEmpty {
      assert(edgeCreases.count == len)
      oec = stride
      stride += sizeof(F32)
    }
    #endif
    #if false // TODO: bones.
      if !bw.isEmpty {
        assert(boneWeights.count == len)
        obw = stride
        stride += sizeof(V4)
      }
      if !bi.isEmpty {
        assert(boneIndices.count == len)
        obi = stride
        stride += sizeof(BoneIndices)
      }
    #endif
    let d = NSMutableData(capacity: len * stride)!
    
    for i in 0..<len {
      d.append(positions[i].vs)
      if !normals.isEmpty         { d.append(normals[i].vs) }
      if !colors.isEmpty          { d.append(colors[i].vs) }
      if !texture0s.isEmpty       { d.append(texture0s[i].vs) }
      #if false // TODO: creases.
        if !vertexCreases.isEmpty   { d.append(vertexCreases[i]) }
        if !edgeCreases.isEmpty     { d.append(edgeCreases[i]) }
      #endif
      #if false // TODO: bones.
        if !bw.isEmpty  { d.append(bw[i]) }
        if !bi.isEmpty  { d.append(bi[i]) }
      #endif
    }
    
    var sources: [SCNGeometrySource] = []
    
    sources.append(SCNGeometrySource(
      data: d as Data,
      semantic: SCNGeometrySourceSemanticVertex,
      vectorCount: len,
      floatComponents: true,
      componentsPerVector: 3,
      bytesPerComponent: sizeof(F32),
      dataOffset: op,
      dataStride: stride))

    if !normals.isEmpty {
      sources.append(SCNGeometrySource(
        data: d as Data,
        semantic: SCNGeometrySourceSemanticNormal,
        vectorCount: len,
        floatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: sizeof(F32),
        dataOffset: on,
        dataStride: stride))
    }
    if !colors.isEmpty {
      sources.append(SCNGeometrySource(
        data: d as Data,
        semantic: SCNGeometrySourceSemanticColor,
        vectorCount: len,
        floatComponents: true,
        componentsPerVector: 4,
        bytesPerComponent: sizeof(F32),
        dataOffset: oc,
        dataStride: stride))
    }
    if !texture0s.isEmpty {
      sources.append(SCNGeometrySource(
        data: d as Data,
        semantic: SCNGeometrySourceSemanticTexcoord,
        vectorCount: len,
        floatComponents: true,
        componentsPerVector: 2,
        bytesPerComponent: sizeof(F32),
        dataOffset: ot0,
        dataStride: stride))
    }
    
    let element: SCNGeometryElement
    let isSmall = (positions.count <= Int(U16.max))
    switch kind {
    case GeomKind.point:
      element = isSmall
        ? SCNGeometryElement(points: points.map { U16($0) })
        : SCNGeometryElement(points: points.map { U32($0) })
    case GeomKind.seg:
      element = isSmall
        ? SCNGeometryElement(segments: segments.map { Seg<U16>($0) })
        : SCNGeometryElement(segments: segments.map { Seg<U32>($0) })
    case GeomKind.tri:
      element = isSmall
        ? SCNGeometryElement(triangles: triangles.map { Tri<U16>($0) })
        : SCNGeometryElement(triangles: triangles.map { Tri<U32>($0) })
    }

    return SCNGeometry(sources: sources, elements: [element])
  }
  
  class func triangle() -> Mesh {
    let r: Flt = sqrt(1.0 / 3.0) // radius of insphere.
    let m = Mesh(name: "triangle")
    m.positions = [
      V3(-r, -r, -r),
      V3(-r,  r,  r),
      V3( r,  r, -r),
    ]
    m.triangles = [
      Tri(0, 1, 2),
      Tri(0, 2, 1),
    ]
    return m
  }
}

