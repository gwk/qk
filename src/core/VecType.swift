// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


protocol VecType {
  typealias ScalarType
}

protocol FloatVecType {

}

protocol IntVecType {

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
