// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation
import SceneKit


extension SCNGeometryElement {

  convenience init<I: IntegerType>(points: [I]) {
    self.init(data: NSData(bytes: points, length: points.count * sizeof(I)),
              primitiveType: .Point,
              primitiveCount: points.count,
              bytesPerIndex: sizeof(I))
  }

  convenience init<I: IntegerType>(segments: [Seg<I>]) {
    self.init(data: NSData(bytes: segments, length: segments.count * sizeof(Seg<I>)),
              primitiveType: .Line,
              primitiveCount: segments.count,
              bytesPerIndex: sizeof(I))
  }

  convenience init<I: IntegerType>(triangles: [Tri<I>]) {
    self.init(data: NSData(bytes: triangles, length: triangles.count * sizeof(Tri<I>)),
              primitiveType: .Triangles,
              primitiveCount: triangles.count,
              bytesPerIndex: sizeof(I))
  }
}


