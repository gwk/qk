// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import SceneKit


extension NSMutableData {

  func append(f32 f: F32) { var f = f; appendBytes(&f, length: sizeof(F32)) }
  func append(v2S v: V2S) { var v = v; appendBytes(&v, length: sizeof(V2S)) }
  func append(v3S v: V3S) { var v = v; appendBytes(&v, length: sizeof(V3S)) }
  func append(v4S v: V4S) { var v = v; appendBytes(&v, length: sizeof(V4S)) }
  
  func bytesF32(offset: Int = 0, index: Int = 0) -> UnsafePointer<F32> {
    return UnsafePointer<F32>(self.bytes + offset) + index
  }
  
  func bytesV2(offset: Int = 0, index: Int = 0) -> UnsafePointer<V2S> {
    return UnsafePointer<V2S>(self.bytes + offset) + index
  }
  
  func bytesV3(offset: Int = 0, index: Int = 0) -> UnsafePointer<V3S> {
    return UnsafePointer<V3S>(self.bytes + offset) + index
  }
  
  func bytesV4(offset: Int = 0, index: Int = 0) -> UnsafePointer<V4S> {
    return UnsafePointer<V4S>(self.bytes + offset) + index
  }
}

enum GeomKind {
  case Point
  case Seg
  case Tri
}

class Mesh {
  
  var positions: [V3] = []
  var normals: [V3] = []
  var colors: [V4] = []
  var texture0s: [V2] = []
  var vertexCreases: [F32] = []
  var edgeCreases: [F32] = []
  //var boneWeights: [V4] = []
  //var boneIndices: [BoneIndices] = []
  
  var points: [U16] = []
  var segments: [Seg] = []
  var triangles: [Tri] = []
  var adjacencies: [Adj] = []
  
  func printContents() {
    print("Mesh:")
    for (i, pos) in positions.enumerate() {
      print("  p[\(i)] = \(pos)")
    }
  }
  
  func addNormFromPos() {
    assert(normals.isEmpty)
    for pos in positions {
      normals.append(pos.norm)
    }
  }
  
  func addColFromPos() {
    assert(colors.isEmpty)
    for pos in positions {
      let color3 = (pos * 0.5 + 0.5).clampToUnit
      colors.append(V4(color3, w: 1))
    }
  }
  
  func addAllPoints() {
    for i in 0..<positions.count {
      points.append(U16(i))
    }
  }
  
  func addAllSegs() {
    for i in 0..<positions.count {
      for j in (i + 1)..<positions.count {
        segments.append(Seg(U16(i), U16(j)))
      }
    }
  }
  
  func addSeg(a: V3, _ b: V3) {
    let i = U16(positions.count)
    positions.appendContentsOf([a, b])
    segments.append(Seg(i, i + 1))
  }
  
  func addQuad(a: V3, _ b: V3, _ c: V3, _ d: V3) {
    let i = U16(positions.count)
    positions.appendContentsOf([a, b, c, d])
    triangles.appendContentsOf([Tri(i, i + 1, i + 2), Tri(i, i + 2, i + 3)])
  }
  
  func geometry(kind: GeomKind = .Tri) -> SCNGeometry {
    
    let len = positions.count

    // data offsets.
    let op = 0 // position data is required.
    var on = 0
    var oc = 0
    var ot0 = 0
    var ovc = 0
    var oec = 0
    //var obw = 0
    //var obi = 0

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
    //if !bw.isEmpty { assert(boneWeights.count == len); obw = stride; stride += sizeof(V4) }
    //if !bi.isEmpty { assert(boneIndices.count == len); obi = stride; stride += sizeof(BoneIndices) }
    
    let d = NSMutableData(capacity: len * stride)!
    
    for i in 0..<len {
      d.append(v3S: positions[i].vs)
      if !normals.isEmpty         { d.append(v3S: normals[i].vs) }
      if !colors.isEmpty          { d.append(v4S: colors[i].vs) }
      if !texture0s.isEmpty       { d.append(v2S: texture0s[i].vs) }
      if !vertexCreases.isEmpty   { d.append(f32: vertexCreases[i]) }
      if !edgeCreases.isEmpty     { d.append(f32: edgeCreases[i]) }
      //if !bw.isEmpty  { d.append(bw[i]) }
      //if !bi.isEmpty  { d.append(bi[i]) }
    }
    
    var sources: [SCNGeometrySource] = []
    
    sources.append(SCNGeometrySource(
      data: d,
      semantic: SCNGeometrySourceSemanticVertex,
      vectorCount: len,
      floatComponents: true,
      componentsPerVector: 3,
      bytesPerComponent: sizeof(F32),
      dataOffset: op,
      dataStride: stride))

    if !normals.isEmpty {
      sources.append(SCNGeometrySource(
        data: d,
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
        data: d,
        semantic: SCNGeometrySourceSemanticColor,
        vectorCount: len,
        floatComponents: true,
        componentsPerVector: 4,
        bytesPerComponent: sizeof(F32),
        dataOffset: oc,
        dataStride: stride))
    }
    
    var elements: [SCNGeometryElement] = []
    switch kind {
      case GeomKind.Point:
        elements.append(SCNGeometryElement(
          data: NSData(bytes: points, length: points.count * sizeof(U16)),
          primitiveType: SCNGeometryPrimitiveType.Point,
          primitiveCount: points.count,
          bytesPerIndex: sizeof(U16)))
      case GeomKind.Seg:
        elements.append(SCNGeometryElement(
          data: NSData(bytes: segments, length: segments.count * sizeof(Seg)),
          primitiveType: SCNGeometryPrimitiveType.Line,
          primitiveCount: segments.count,
          bytesPerIndex: sizeof(U16)))
      case GeomKind.Tri:
        elements.append(SCNGeometryElement(
          data: NSData(bytes: triangles, length: triangles.count * sizeof(Tri)),
          primitiveType: SCNGeometryPrimitiveType.Triangles,
          primitiveCount: triangles.count,
          bytesPerIndex: sizeof(U16)))
    }

    return SCNGeometry(sources: sources, elements: elements)
  }
  
  class func triangle() -> Mesh {
    let r: Flt = sqrt(1.0 / 3.0) // radius of insphere.
    let m = Mesh()
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
