// © 2015 George King. Permission to use this file is granted in license-qk.txt.
// This file is generated by gen-vec.py.
  
import Darwin
import CoreGraphics


extension CGPoint : VecType2, FloatVecType, CustomStringConvertible {
  typealias Scalar = Flt
  typealias FloatType = Flt
  typealias VSType = V2S
  typealias VDType = V2D
  typealias VU8Type = V2U8
  init(_ v: V2S) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V2D) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V2I) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V2U8) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V3S) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V3D) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V3I) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V3U8) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V4S) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V4D) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V4I) {
    self.init(Scalar(v.x), Scalar(v.y))
  }
  init(_ v: V4U8) {
    self.init(Scalar(v.x), Scalar(v.y))
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
  var l: Scalar {
    get { return x }
    set { x = newValue }
  }
  var a: Scalar {
    get { return y }
    set { y = newValue }
  }

  var allNormal: Bool { return x.isNormal && y.isNormal }
  var allFinite: Bool { return x.isFinite && y.isFinite }
  var allZero: Bool { return x.isNormal && y.isNormal }
  var anySubnormal: Bool { return x.isSubnormal || y.isSubnormal}
  var anyInfite: Bool { return x.isInfinite || y.isInfinite}
  var anyNaN: Bool { return x.isNaN || y.isNaN}
  var norm: CGPoint { return self / self.len }
  var clampToUnit: CGPoint { return CGPoint(clamp(x, min: 0, max: 1), clamp(y, min: 0, max: 1)) }
  var toU8Pixel: VU8Type { return VU8Type(U8(clamp(x * 255, min: 0, max: 255)), U8(clamp(y * 255, min: 0, max: 255))) }

  func dot(b: CGPoint) -> Scalar { return (x * b.x) + (y * b.y) }
  func angle(b: CGPoint) -> Scalar { return acos(self.dot(b) / (self.len * b.len)) }
  func lerp(b: CGPoint, _ t: Scalar) -> CGPoint { return self * (1 - t) + b * t }

}

func +(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x + b.x, a.y + b.y) }
func -(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x - b.x, a.y - b.y) }
func *(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x * b.x, a.y * b.y) }
func /(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x / b.x, a.y / b.y) }
func +(a: CGPoint, s: Flt) -> CGPoint { return CGPoint(a.x + s, a.y + s) }
func -(a: CGPoint, s: Flt) -> CGPoint { return CGPoint(a.x - s, a.y - s) }
func *(a: CGPoint, s: Flt) -> CGPoint { return CGPoint(a.x * s, a.y * s) }
func /(a: CGPoint, s: Flt) -> CGPoint { return CGPoint(a.x / s, a.y / s) }

