// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import Metal


extension MTLVertexAttributeDescriptorArray {

  func update(descriptors: [(format: MTLVertexFormat, offset: Int, bufferIndex: Int)]) {
    for (i, t) in descriptors.enumerate() {
      let desc = self[i]
      desc.format = t.format
      desc.offset = t.offset
      desc.bufferIndex = t.bufferIndex
    }
  }
}

