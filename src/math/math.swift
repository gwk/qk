// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation

typealias V2 = V2F32
typealias V3 = V3F32
typealias V4 = V4F32

func sqr(a: F32) -> F32 { return a * a }
func sqr(a: F64) -> F64 { return a * a }

func sqrrt(a: F32) -> F32 { return sqrtf(a) }
func sqrrt(a: F64) -> F64 { return sqrt(a) }

func clamp<T: FloatingPointType>(a: T, l: T, h: T) -> T {
  if a < l { return l }
  if a > h { return h }
  return a
}
