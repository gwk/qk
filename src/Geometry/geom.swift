// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


struct Tri<I: IntegerType where I: IntegerInitable>: CustomStringConvertible {
  var a, b, c: I
  
  init(_ a: I, _ b: I, _ c: I) {
    assert(a < b && a < c)
    self.a = a
    self.b = b
    self.c = c
  }

  init(_ tri: Tri<Int>) {
    self.init(I(tri.a), I(tri.b), I(tri.c))
  }

  var description: String { return "Tri(\(a), \(b), \(c))" }

  var swizzled: Tri<I> { return Tri(a, c, b) }
}


struct Seg<I: IntegerType where I: IntegerInitable, I: Comparable>: CustomStringConvertible, Comparable {
  var a, b: I

  init(_ a: I, _ b: I) {
    assert(a != b)
    if (a < b) {
      self.a = a
      self.b = b
    } else {
      self.a = b
      self.b = a
    }
  }

  init(_ seg: Seg<Int>) {
    self.init(I(seg.a), I(seg.b))
  }

  var description: String { return "Seg(\(a), \(b))" }
}

func ==<I>(l: Seg<I>, r: Seg<I>) -> Bool {
  return l.a == r.a && l.b == r.b
}

func <<I>(l: Seg<I>, r: Seg<I>) -> Bool {
  if (l.a == r.a) {
    return l.b < r.b
  } else {
    return l.a < r.a
  }
}


struct Adj {
  var a, b: Int
  init(_ a: Int, _ b: Int) {
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

