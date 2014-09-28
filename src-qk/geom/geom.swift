// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation

struct Tri {
  var a, b, c: U16
  init(_ a: U16, _ b: U16, _ c: U16) {
    self.a = a
    self.b = b
    self.c = c
  }
}

struct Seg {
  var a, b: U16
  init(_ a: U16, _ b: U16) {
    if (a < b) {
      self.a = a
      self.b = b
    } else {
      self.a = b
      self.b = a
    }
  }
}

struct Adj {
  var a, b: U16
  init(_ a: U16, _ b: U16) {
    if (a < b) {
      self.a = a
      self.b = b
    } else {
      self.a = b
      self.b = a
    }
  }
}

typealias Vertex = V3
/*
V Vertex
N Normal
C Color
T Texcoord
P VertexCrease
E EdgeCrease
W BoneWeights
I BoneIndices
*/


func EulerEdgeCount(vertexCount: Int, faceCount: Int) -> Int {
  return vertexCount + faceCount - 2
}

