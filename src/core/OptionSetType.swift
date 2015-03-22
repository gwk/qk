// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


protocol OptionSetType: Equatable {
  typealias OptionType;
  var val: Uns { get }
  init(_ val: Uns)
  init(_ opt: OptionType)
}

func ==<T: OptionSetType>(l: T, r: T) -> Bool { return l.val == r.val }
func &<T: OptionSetType>(l: T, r: T) -> T { return T(l.val & r.val) }
func |<T: OptionSetType>(l: T, r: T) -> T { return T(l.val | r.val) }
func ^<T: OptionSetType>(l: T, r: T) -> T { return T(l.val ^ r.val) }
prefix func ~<T: OptionSetType>(x: T) -> T { return T(~x.val) }

func union<T: OptionSetType>(options: [T.OptionType]) -> T {
  return options.reduce(T(0)) {
    return $0 | T($1)
  }
}

func union<T: OptionSetType>(options: T.OptionType...) -> T {
  return union(options)
}
