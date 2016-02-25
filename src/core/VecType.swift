// © 2015 George King. Permission to use this file is granted in license-qk.txt.


protocol VecType: Equatable, CustomStringConvertible {
  associatedtype Scalar: ArithmeticType
  associatedtype FloatType: ArithmeticFloatType
  associatedtype VSType
  associatedtype VDType
  
  var x: Scalar { get }
  var y: Scalar { get }
  var vs: VSType { get }
  var vd: VDType { get }
  var sqrLen: FloatType { get }
  var len: FloatType { get }

  func +(l: Self, r: Self) -> Self
  func -(l: Self, r: Self) -> Self
  func *(l: Self, r: Scalar) -> Self
  func /(l: Self, r: Scalar) -> Self
}

extension VecType {
  var len: FloatType { return sqrLen.sqrt }
  func dist(b: Self) -> FloatType { return (b - self).len }
}

protocol VecType2: VecType {
  init(_ x: Scalar, _ y: Scalar)
  var x: Scalar { get }
  var y: Scalar { get }
}

protocol VecType3: VecType {
  init(_ x: Scalar, _ y: Scalar, _ z: Scalar)
  var x: Scalar { get }
  var y: Scalar { get }
  var z: Scalar { get }
}

protocol VecType4: VecType {
  init(_ x: Scalar, _ y: Scalar, _ z: Scalar, _ w: Scalar)
  var x: Scalar { get }
  var y: Scalar { get }
  var z: Scalar { get }
  var w: Scalar { get }
}

protocol FloatVecType: VecType {
  var norm: Self { get }
  var clampToUnit: Self { get }
  func dist(b: Self) -> Scalar
  func dot(b: Self) -> Scalar
  func angle(b: Self) -> Scalar
}

protocol IntVecType: VecType {

}

