// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation

struct Tri: Printable {
  var a, b, c: U16
  
  init(_ a: U16, _ b: U16, _ c: U16) {
    assert(a < b && a < c)
    self.a = a
    self.b = b
    self.c = c
  }
  
  var description: String { return "Tri(\(a), \(b), \(c))" }
}

struct Seg: Printable {
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
  
  var description: String { return "Seg(\(a), \(b))" }
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

func EulerEdgeCount(vertexCount: Int, faceCount: Int) -> Int {
  return vertexCount + faceCount - 2
}

