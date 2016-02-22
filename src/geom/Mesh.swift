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
  
  var p: [V3] = [] // position.
  var n: [V3] = [] // normal.
  var c: [V4] = [] // color.
  var t0: [V2] = [] // texcoord.
  var vc: [F32] = [] // vertexCrease.
  var ec: [F32] = [] // edgeCrease.
  //var bw: [V4] = [] // boneWeights.
  //var bi: [BoneIndices] = [] // boneIndices.
  
  var point: [U16] = []
  var seg: [Seg] = []
  var tri: [Tri] = []
  var adj: [Adj] = []
  
  func printContents() {
    print("Mesh:")
    for (i, pos) in p.enumerate() {
      print("  p[\(i)] = \(pos)")
    }
  }
  
  func addNormFromPos() {
    assert(n.isEmpty)
    for pos in p {
      n.append(pos.norm)
    }
  }
  
  func addColFromPos() {
    assert(c.isEmpty)
    for pos in p {
      let color3 = (pos * 0.5 + 0.5).clampToUnit
      c.append(V4(color3, w: 1))
    }
  }
  
  func addAllPoints() {
    for i in 0..<p.count {
      point.append(U16(i))
    }
  }
  
  func addAllSegs() {
    for i in 0..<p.count {
      for j in (i + 1)..<p.count {
        seg.append(Seg(U16(i), U16(j)))
      }
    }
  }
  
  func addSeg(a: V3, _ b: V3) {
    let i = U16(p.count)
    p.appendContentsOf([a, b])
    seg.append(Seg(i, i + 1))
  }
  
  func addQuad(a: V3, _ b: V3, _ c: V3, _ d: V3) {
    let i = U16(p.count)
    p.appendContentsOf([a, b, c, d])
    tri.appendContentsOf([Tri(i, i + 1, i + 2), Tri(i, i + 2, i + 3)])
  }
  
  func geometry(kind: GeomKind = .Tri) -> SCNGeometry {
    
    let len = p.count

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
    if !n.isEmpty   { assert(n.count == len); on = stride; stride += sizeof(V3S) }
    if !c.isEmpty   { assert(c.count == len); oc = stride; stride += sizeof(V4S) }
    if !t0.isEmpty  { assert(t0.count == len); ot0 = stride; stride += sizeof(V2S) }
    if !vc.isEmpty  { assert(vc.count == len); ovc = stride; stride += sizeof(F32) }
    if !ec.isEmpty  { assert(ec.count == len); oec = stride; stride += sizeof(F32) }
    //if !bw.isEmpty  { assert(bw.count == len); obw = stride; stride += sizeof(V4) }
    //if !bi.isEmpty  { assert(bi.count == len); obi = stride; stride += sizeof(BoneIndices) }
    
    let d = NSMutableData(capacity: len * stride)!
    
    for i in 0..<len {
      d.append(v3S: p[i].vs)
      if !n.isEmpty   { d.append(v3S: n[i].vs) }
      if !c.isEmpty   { d.append(v4S: c[i].vs) }
      if !t0.isEmpty  { d.append(v2S: t0[i].vs) }
      if !vc.isEmpty  { d.append(f32: vc[i]) }
      if !ec.isEmpty  { d.append(f32: ec[i]) }
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

    if !n.isEmpty {
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
    if !c.isEmpty {
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
          data: NSData(bytes: point, length: point.count * sizeof(U16)),
          primitiveType: SCNGeometryPrimitiveType.Point,
          primitiveCount: point.count,
          bytesPerIndex: sizeof(U16)))
      case GeomKind.Seg:
        elements.append(SCNGeometryElement(
          data: NSData(bytes: seg, length: seg.count * sizeof(Seg)),
          primitiveType: SCNGeometryPrimitiveType.Line,
          primitiveCount: seg.count,
          bytesPerIndex: sizeof(U16)))
      case GeomKind.Tri:
        elements.append(SCNGeometryElement(
          data: NSData(bytes: tri, length: tri.count * sizeof(Tri)),
          primitiveType: SCNGeometryPrimitiveType.Triangles,
          primitiveCount: tri.count,
          bytesPerIndex: sizeof(U16)))
    }

    return SCNGeometry(sources: sources, elements: elements)
  }
  
  class func triangle() -> Mesh {
    let r: Flt = sqrt(1.0 / 3.0) // radius of insphere.
    let m = Mesh()
    m.p = [
      V3(-r, -r, -r),
      V3(-r,  r,  r),
      V3( r,  r, -r),
    ]
    m.tri = [
      Tri(0, 1, 2),
      Tri(0, 2, 1),
    ]
    return m
  }
}
