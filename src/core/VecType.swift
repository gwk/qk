// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


protocol VecType: Equatable, Printable {
  typealias ScalarType
  typealias FloatType
  typealias VSType
  typealias VDType
  
  var vs: VSType { get }
  var vd: VDType { get }
  var sqrLen: FloatType { get }
  var len: FloatType { get }
}

protocol FloatVecType: VecType {
  var norm: Self { get }
  var clampToUnit: Self { get }
  func dist(b: Self) -> ScalarType
  func dot(b: Self) -> ScalarType
  func angle(b: Self) -> ScalarType
}

protocol IntVecType: VecType {

}

protocol VecType2: VecType {
  typealias ScalarType
  var x: ScalarType { get }
  var y: ScalarType { get }
}

protocol VecType3: VecType {
  typealias ScalarType
  var x: ScalarType { get }
  var y: ScalarType { get }
  var z: ScalarType { get }
}

protocol VecType4: VecType {
  typealias ScalarType
  var x: ScalarType { get }
  var y: ScalarType { get }
  var z: ScalarType { get }
  var w: ScalarType { get }
}
