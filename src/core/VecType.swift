// © 2015 George King. Permission to use this file is granted in license-qk.txt.


protocol VecType: Equatable, CustomStringConvertible {
  typealias Scalar: ArithmeticType
  typealias FloatType: FloatingPointType
  typealias VSType
  typealias VDType
  
  var vs: VSType { get }
  var vd: VDType { get }
  var sqrLen: FloatType { get }
  var len: FloatType { get }
}

protocol VecType2: VecType {
  typealias Scalar
  var x: Scalar { get }
  var y: Scalar { get }
}

protocol VecType3: VecType {
  typealias Scalar
  var x: Scalar { get }
  var y: Scalar { get }
  var z: Scalar { get }
}

protocol VecType4: VecType {
  typealias Scalar
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

