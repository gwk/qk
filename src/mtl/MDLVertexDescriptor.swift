// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import ModelIO


extension MDLVertexDescriptor {

  var attrs: [MDLVertexAttribute] {
    get { return attributes.array() }
  }
}

