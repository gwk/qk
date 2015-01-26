// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.


func clamp<T: IntegerArithmeticType>(a: T, l: T, h: T) -> T {
  if a < l { return l }
  if a > h { return h }
  return a
}

func clamp<T: FloatingPointType>(a: T, l: T, h: T) -> T {
  if a < l { return l }
  if a > h { return h }
  return a
}

