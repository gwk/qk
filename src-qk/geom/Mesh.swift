// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import SceneKit

class Mesh {
  var v: [Vertex] = []
  var e: [Seg] = []
  var t: [Tri] = []
  var a: [Adj] = []

  init(v:[Vertex], e:[Seg], t:[Tri]) {
    self.v = v
    self.e = e
    self.t = t
  }
  
  func geometry() -> SCNGeometry {
    
    let vertices = SCNGeometrySource(
      data: NSData(bytes: v, length: v.count * sizeof(Vertex)),
      semantic: SCNGeometrySourceSemanticVertex,
      vectorCount: v.count,
      floatComponents: true,
      componentsPerVector: 3,
      bytesPerComponent: sizeof(GLfloat),
      dataOffset: 0,
      dataStride: sizeof(Vertex))
    
    let elements = SCNGeometryElement(
      data: NSData(bytes: t, length: t.count * sizeof(Tri)),
      primitiveType: SCNGeometryPrimitiveType.Triangles,
      primitiveCount: t.count,
      bytesPerIndex: sizeof(U16))
    
    return SCNGeometry(sources:[vertices], elements:[elements])
  }
}


