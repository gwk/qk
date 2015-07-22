// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.
// This file is generated by gen-vec.py.
  
import Darwin
import CoreGraphics


extension CGPoint : VecType2, FloatVecType, CustomStringConvertible {
  typealias ScalarType = Flt
  typealias FloatType = Flt
  typealias VSType = V2S
  typealias VDType = V2D
  init(_ v: V2S) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  init(_ v: V2D) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  init(_ v: V2I) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  init(_ v: V3S) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  init(_ v: V3D) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  init(_ v: V3I) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  init(_ v: V4S) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  init(_ v: V4D) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  init(_ v: V4I) {
    self.init(ScalarType(v.x), ScalarType(v.y))
  }
  static let zero = CGPoint(0, 0)
  static let unitX = CGPoint(1, 0)
  static let unitY = CGPoint(0, 1)
  public var description: String { return "CGPoint(\(x), \(y))" }
  var vs: V2S { return V2S(F32(x), F32(y)) }
  var vd: V2D { return V2D(F64(x), F64(y)) }
  var sqrLen: FloatType { return (FloatType(x).sqr + FloatType(y).sqr) }
  var len: FloatType { return sqrLen.sqrt }
  var aspect: FloatType { return FloatType(x) / FloatType(y) }
  func dist(b: CGPoint) -> FloatType { return (b - self).len }
  var l: ScalarType { return x }
  var a: ScalarType { return y }

  var allNormal: Bool { return x.isNormal && y.isNormal }
  var allFinite: Bool { return x.isFinite && y.isFinite }
  var allZero: Bool { return x.isNormal && y.isNormal }
  var anySubnormal: Bool { return x.isSubnormal || y.isSubnormal}
  var anyInfite: Bool { return x.isInfinite || y.isInfinite}
  var anyNaN: Bool { return x.isNaN || y.isNaN}

  var norm: CGPoint { return self / self.len }
  var clampToUnit: CGPoint { return CGPoint(clamp(x, l: 0, h: 1), clamp(y, l: 0, h: 1)) }
  func dot(b: CGPoint) -> ScalarType { return (x * b.x) + (y * b.y) }
  func angle(b: CGPoint) -> ScalarType { return acos(self.dot(b) / (self.len * b.len)) }
  func lerp(b: CGPoint, _ t: ScalarType) -> CGPoint { return self * (1 - t) + b * t }

}

func +(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x + b.x, a.y + b.y) }
func -(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x - b.x, a.y - b.y) }
func *(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x * b.x, a.y * b.y) }
func /(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x / b.x, a.y / b.y) }
func +(a: CGPoint, s: Flt) -> CGPoint { return CGPoint(a.x + s, a.y + s) }
func -(a: CGPoint, s: Flt) -> CGPoint { return CGPoint(a.x - s, a.y - s) }
func *(a: CGPoint, s: Flt) -> CGPoint { return CGPoint(a.x * s, a.y * s) }
func /(a: CGPoint, s: Flt) -> CGPoint { return CGPoint(a.x / s, a.y / s) }

