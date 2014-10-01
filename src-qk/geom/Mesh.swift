// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import SceneKit


// hack for the busted type system.
func ptr_id(p: UnsafePointer<F32>) -> UnsafePointer<F32> { return p }
func ptr_id(p: UnsafePointer<V2>) -> UnsafePointer<V2> { return p }
func ptr_id(p: UnsafePointer<V3>) -> UnsafePointer<V3> { return p }
func ptr_id(p: UnsafePointer<V4>) -> UnsafePointer<V4> { return p }

extension NSMutableData {

  func append(var f: F32) { appendBytes(ptr_id(&f), length: sizeof(F32)) }
  func append(var v: V2) { appendBytes(ptr_id(&v), length: sizeof(V2)) }
  func append(var v: V3) { appendBytes(ptr_id(&v), length: sizeof(V3)) }
  func append(var v: V4) { appendBytes(ptr_id(&v), length: sizeof(V4)) }
  
  func bytesF32(offset: Int = 0, index: Int = 0) -> UnsafePointer<F32> {
    return UnsafePointer<F32>(self.bytes + offset) + index
  }
  
  func bytesV2(offset: Int = 0, index: Int = 0) -> UnsafePointer<V2> {
    return UnsafePointer<V2>(self.bytes + offset) + index
  }
  
  func bytesV3(offset: Int = 0, index: Int = 0) -> UnsafePointer<V3> {
    return UnsafePointer<V3>(self.bytes + offset) + index
  }
  
  func bytesV4(offset: Int = 0, index: Int = 0) -> UnsafePointer<V4> {
    return UnsafePointer<V4>(self.bytes + offset) + index
  }
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
  
  var seg: [Seg] = []
  var tri: [Tri] = []
  var adj: [Adj] = []
  
  func geometry() -> SCNGeometry {
    
    let len = p.count

    let op = 0 // position data is required.
    var on = 0
    var oc = 0
    var ot0 = 0
    var ovc = 0
    var oec = 0
    //var obw = 0
    //var obi = 0

    var stride = sizeof(V3)
    if !n.isEmpty   { assert(n.count == len); on = stride; stride += sizeof(V3) }
    if !c.isEmpty   { assert(c.count == len); oc = stride; stride += sizeof(V4) }
    if !t0.isEmpty  { assert(t0.count == len); ot0 = stride; stride += sizeof(V2) }
    if !vc.isEmpty  { assert(vc.count == len); ovc = stride; stride += sizeof(F32) }
    if !ec.isEmpty  { assert(ec.count == len); oec = stride; stride += sizeof(F32) }
    //if !bw.isEmpty  { assert(bw.count == len); obw = stride; stride += sizeof(V4) }
    //if !bi.isEmpty  { assert(bi.count == len); obi = stride; stride += sizeof(BoneIndices) }
    
    let d = NSMutableData(capacity: len * stride)!
    
    for i in 0..<len {
      d.append(p[i])
      if !n.isEmpty   { d.append(n[i]) }
      if !c.isEmpty   { d.append(c[i]) }
      if !t0.isEmpty  { d.append(t0[i]) }
      if !vc.isEmpty  { d.append(vc[i]) }
      if !ec.isEmpty  { d.append(ec[i]) }
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
    elements.append(SCNGeometryElement(
      data: NSData(bytes: tri, length: tri.count * sizeof(Tri)),
      primitiveType: SCNGeometryPrimitiveType.Triangles,
      primitiveCount: tri.count,
      bytesPerIndex: sizeof(U16)))
    
    return SCNGeometry(sources:sources, elements:elements)
  }
}


