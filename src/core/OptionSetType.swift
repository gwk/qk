// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


protocol OptionSetType: Equatable {
  var val: Uns { get }
  init()
  init(_ val: Uns)
}

func ==<T: OptionSetType>(l: T, r: T) -> Bool { return l.val == r.val }
func &<T: OptionSetType>(l: T, r: T) -> T { return T(l.val & r.val) }
func |<T: OptionSetType>(l: T, r: T) -> T { return T(l.val | r.val) }
func ^<T: OptionSetType>(l: T, r: T) -> T { return T(l.val ^ r.val) }
prefix func ~<T: OptionSetType>(x: T) -> T { return T(~x.val) }
