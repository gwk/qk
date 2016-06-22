// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Foundation
import SceneKit


extension SCNGeometryElement {

  convenience init<I: Integer>(points: [I]) {
    self.init(data: Data(bytes: UnsafePointer<UInt8>(points), count: points.count * sizeof(I)),
              primitiveType: .point,
              primitiveCount: points.count,
              bytesPerIndex: sizeof(I))
  }

  convenience init<I: Integer>(segments: [Seg<I>]) {
    self.init(data: Data(bytes: UnsafePointer<UInt8>(segments), count: segments.count * sizeof(Seg<I>)),
              primitiveType: .line,
              primitiveCount: segments.count,
              bytesPerIndex: sizeof(I))
  }

  convenience init<I: Integer>(triangles: [Tri<I>]) {
    self.init(data: Data(bytes: UnsafePointer<UInt8>(triangles), count: triangles.count * sizeof(Tri<I>)),
              primitiveType: .triangles,
              primitiveCount: triangles.count,
              bytesPerIndex: sizeof(I))
  }
}


