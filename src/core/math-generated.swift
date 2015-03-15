// © 2014-2015 George King.
// Permission to use this file is granted in license-qk.txt.
// This file is generated by gen-math.py.

  
struct V2S: Printable, Equatable {
  var x, y: F32
  init(_ x: F32 = 0, _ y: F32 = 0) {
    self.x = x
    self.y = y
  }
  init(_ v: V2S) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  init(_ v: V2D) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  init(_ v: V2I) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  init(_ v: V3S) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  init(_ v: V3D) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  init(_ v: V3I) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  init(_ v: V4S) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  init(_ v: V4D) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  init(_ v: V4I) {
    self.x = F32(v.x)
    self.y = F32(v.y)
  }
  static let zero = V2S(0, 0)
  var description: String { return "V2S(\(x), \(y))" }
  var vs: V2S { return V2S(F32(x), F32(y)) }
  var vd: V2D { return V2D(F64(x), F64(y)) }
  var len: F32 { return (x.sqr + y.sqr).sqrt }
  var norm: V2S { return self / self.len }
  var clampToUnit: V2S { return V2S(clamp(x, 0, 1), clamp(y, 0, 1)) }
}

func +(a: V2S, b: V2S) -> V2S { return V2S(a.x + b.x, a.y + b.y) }
func -(a: V2S, b: V2S) -> V2S { return V2S(a.x - b.x, a.y - b.y) }
func *(a: V2S, b: V2S) -> V2S { return V2S(a.x * b.x, a.y * b.y) }
func /(a: V2S, b: V2S) -> V2S { return V2S(a.x / b.x, a.y / b.y) }
func +(a: V2S, s: F32) -> V2S { return V2S(a.x + s, a.y + s) }
func -(a: V2S, s: F32) -> V2S { return V2S(a.x - s, a.y - s) }
func *(a: V2S, s: F32) -> V2S { return V2S(a.x * s, a.y * s) }
func /(a: V2S, s: F32) -> V2S { return V2S(a.x / s, a.y / s) }

func ==(a: V2S, b: V2S) -> Bool {
  return a.x == b.x && a.y == b.y
}

struct V2D: Printable, Equatable {
  var x, y: F64
  init(_ x: F64 = 0, _ y: F64 = 0) {
    self.x = x
    self.y = y
  }
  init(_ v: V2S) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  init(_ v: V2D) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  init(_ v: V2I) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  init(_ v: V3S) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  init(_ v: V3D) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  init(_ v: V3I) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  init(_ v: V4S) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  init(_ v: V4D) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  init(_ v: V4I) {
    self.x = F64(v.x)
    self.y = F64(v.y)
  }
  static let zero = V2D(0, 0)
  var description: String { return "V2D(\(x), \(y))" }
  var vs: V2S { return V2S(F32(x), F32(y)) }
  var vd: V2D { return V2D(F64(x), F64(y)) }
  var len: F64 { return (x.sqr + y.sqr).sqrt }
  var norm: V2D { return self / self.len }
  var clampToUnit: V2D { return V2D(clamp(x, 0, 1), clamp(y, 0, 1)) }
}

func +(a: V2D, b: V2D) -> V2D { return V2D(a.x + b.x, a.y + b.y) }
func -(a: V2D, b: V2D) -> V2D { return V2D(a.x - b.x, a.y - b.y) }
func *(a: V2D, b: V2D) -> V2D { return V2D(a.x * b.x, a.y * b.y) }
func /(a: V2D, b: V2D) -> V2D { return V2D(a.x / b.x, a.y / b.y) }
func +(a: V2D, s: F64) -> V2D { return V2D(a.x + s, a.y + s) }
func -(a: V2D, s: F64) -> V2D { return V2D(a.x - s, a.y - s) }
func *(a: V2D, s: F64) -> V2D { return V2D(a.x * s, a.y * s) }
func /(a: V2D, s: F64) -> V2D { return V2D(a.x / s, a.y / s) }

func ==(a: V2D, b: V2D) -> Bool {
  return a.x == b.x && a.y == b.y
}

struct V2I: Printable, Equatable {
  var x, y: Int
  init(_ x: Int = 0, _ y: Int = 0) {
    self.x = x
    self.y = y
  }
  init(_ v: V2S) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  init(_ v: V2D) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  init(_ v: V2I) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  init(_ v: V3S) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  init(_ v: V3D) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  init(_ v: V3I) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  init(_ v: V4S) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  init(_ v: V4D) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  init(_ v: V4I) {
    self.x = Int(v.x)
    self.y = Int(v.y)
  }
  static let zero = V2I(0, 0)
  var description: String { return "V2I(\(x), \(y))" }
  var vs: V2S { return V2S(F32(x), F32(y)) }
  var vd: V2D { return V2D(F64(x), F64(y)) }
  var len: Flt { return (Flt(x).sqr + Flt(y).sqr).sqrt }
  var clampToUnit: V2I { return V2I(clamp(x, 0, 1), clamp(y, 0, 1)) }
}

func +(a: V2I, b: V2I) -> V2I { return V2I(a.x + b.x, a.y + b.y) }
func -(a: V2I, b: V2I) -> V2I { return V2I(a.x - b.x, a.y - b.y) }
func *(a: V2I, b: V2I) -> V2I { return V2I(a.x * b.x, a.y * b.y) }
func /(a: V2I, b: V2I) -> V2I { return V2I(a.x / b.x, a.y / b.y) }
func +(a: V2I, s: Int) -> V2I { return V2I(a.x + s, a.y + s) }
func -(a: V2I, s: Int) -> V2I { return V2I(a.x - s, a.y - s) }
func *(a: V2I, s: Int) -> V2I { return V2I(a.x * s, a.y * s) }
func /(a: V2I, s: Int) -> V2I { return V2I(a.x / s, a.y / s) }

func ==(a: V2I, b: V2I) -> Bool {
  return a.x == b.x && a.y == b.y
}

struct V3S: Printable, Equatable {
  var x, y, z: F32
  init(_ x: F32 = 0, _ y: F32 = 0, _ z: F32 = 0) {
    self.x = x
    self.y = y
    self.z = z
  }
  init(_ v: V3S) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
  }
  init(_ v: V3D) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
  }
  init(_ v: V3I) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
  }
  init(_ v: V4S) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
  }
  init(_ v: V4D) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
  }
  init(_ v: V4I) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
  }
  init(_ v: V2S, _ s: F32) {
    self.x = v.x
    self.y = v.y
    self.z = s
  }
  static let zero = V3S(0, 0, 0)
  var description: String { return "V3S(\(x), \(y), \(z))" }
  var vs: V3S { return V3S(F32(x), F32(y), F32(z)) }
  var vd: V3D { return V3D(F64(x), F64(y), F64(z)) }
  var len: F32 { return (x.sqr + y.sqr + z.sqr).sqrt }
  var norm: V3S { return self / self.len }
  var clampToUnit: V3S { return V3S(clamp(x, 0, 1), clamp(y, 0, 1), clamp(z, 0, 1)) }
  var r: F32 { return x }
  var g: F32 { return y }
  var b: F32 { return z }
}

func +(a: V3S, b: V3S) -> V3S { return V3S(a.x + b.x, a.y + b.y, a.z + b.z) }
func -(a: V3S, b: V3S) -> V3S { return V3S(a.x - b.x, a.y - b.y, a.z - b.z) }
func *(a: V3S, b: V3S) -> V3S { return V3S(a.x * b.x, a.y * b.y, a.z * b.z) }
func /(a: V3S, b: V3S) -> V3S { return V3S(a.x / b.x, a.y / b.y, a.z / b.z) }
func +(a: V3S, s: F32) -> V3S { return V3S(a.x + s, a.y + s, a.z + s) }
func -(a: V3S, s: F32) -> V3S { return V3S(a.x - s, a.y - s, a.z - s) }
func *(a: V3S, s: F32) -> V3S { return V3S(a.x * s, a.y * s, a.z * s) }
func /(a: V3S, s: F32) -> V3S { return V3S(a.x / s, a.y / s, a.z / s) }

func ==(a: V3S, b: V3S) -> Bool {
  return a.x == b.x && a.y == b.y && a.z == b.z
}

struct V3D: Printable, Equatable {
  var x, y, z: F64
  init(_ x: F64 = 0, _ y: F64 = 0, _ z: F64 = 0) {
    self.x = x
    self.y = y
    self.z = z
  }
  init(_ v: V3S) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
  }
  init(_ v: V3D) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
  }
  init(_ v: V3I) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
  }
  init(_ v: V4S) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
  }
  init(_ v: V4D) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
  }
  init(_ v: V4I) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
  }
  init(_ v: V2D, _ s: F64) {
    self.x = v.x
    self.y = v.y
    self.z = s
  }
  static let zero = V3D(0, 0, 0)
  var description: String { return "V3D(\(x), \(y), \(z))" }
  var vs: V3S { return V3S(F32(x), F32(y), F32(z)) }
  var vd: V3D { return V3D(F64(x), F64(y), F64(z)) }
  var len: F64 { return (x.sqr + y.sqr + z.sqr).sqrt }
  var norm: V3D { return self / self.len }
  var clampToUnit: V3D { return V3D(clamp(x, 0, 1), clamp(y, 0, 1), clamp(z, 0, 1)) }
  var r: F64 { return x }
  var g: F64 { return y }
  var b: F64 { return z }
}

func +(a: V3D, b: V3D) -> V3D { return V3D(a.x + b.x, a.y + b.y, a.z + b.z) }
func -(a: V3D, b: V3D) -> V3D { return V3D(a.x - b.x, a.y - b.y, a.z - b.z) }
func *(a: V3D, b: V3D) -> V3D { return V3D(a.x * b.x, a.y * b.y, a.z * b.z) }
func /(a: V3D, b: V3D) -> V3D { return V3D(a.x / b.x, a.y / b.y, a.z / b.z) }
func +(a: V3D, s: F64) -> V3D { return V3D(a.x + s, a.y + s, a.z + s) }
func -(a: V3D, s: F64) -> V3D { return V3D(a.x - s, a.y - s, a.z - s) }
func *(a: V3D, s: F64) -> V3D { return V3D(a.x * s, a.y * s, a.z * s) }
func /(a: V3D, s: F64) -> V3D { return V3D(a.x / s, a.y / s, a.z / s) }

func ==(a: V3D, b: V3D) -> Bool {
  return a.x == b.x && a.y == b.y && a.z == b.z
}

struct V3I: Printable, Equatable {
  var x, y, z: Int
  init(_ x: Int = 0, _ y: Int = 0, _ z: Int = 0) {
    self.x = x
    self.y = y
    self.z = z
  }
  init(_ v: V3S) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
  }
  init(_ v: V3D) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
  }
  init(_ v: V3I) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
  }
  init(_ v: V4S) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
  }
  init(_ v: V4D) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
  }
  init(_ v: V4I) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
  }
  init(_ v: V2I, _ s: Int) {
    self.x = v.x
    self.y = v.y
    self.z = s
  }
  static let zero = V3I(0, 0, 0)
  var description: String { return "V3I(\(x), \(y), \(z))" }
  var vs: V3S { return V3S(F32(x), F32(y), F32(z)) }
  var vd: V3D { return V3D(F64(x), F64(y), F64(z)) }
  var len: Flt { return (Flt(x).sqr + Flt(y).sqr + Flt(z).sqr).sqrt }
  var clampToUnit: V3I { return V3I(clamp(x, 0, 1), clamp(y, 0, 1), clamp(z, 0, 1)) }
  var r: Int { return x }
  var g: Int { return y }
  var b: Int { return z }
}

func +(a: V3I, b: V3I) -> V3I { return V3I(a.x + b.x, a.y + b.y, a.z + b.z) }
func -(a: V3I, b: V3I) -> V3I { return V3I(a.x - b.x, a.y - b.y, a.z - b.z) }
func *(a: V3I, b: V3I) -> V3I { return V3I(a.x * b.x, a.y * b.y, a.z * b.z) }
func /(a: V3I, b: V3I) -> V3I { return V3I(a.x / b.x, a.y / b.y, a.z / b.z) }
func +(a: V3I, s: Int) -> V3I { return V3I(a.x + s, a.y + s, a.z + s) }
func -(a: V3I, s: Int) -> V3I { return V3I(a.x - s, a.y - s, a.z - s) }
func *(a: V3I, s: Int) -> V3I { return V3I(a.x * s, a.y * s, a.z * s) }
func /(a: V3I, s: Int) -> V3I { return V3I(a.x / s, a.y / s, a.z / s) }

func ==(a: V3I, b: V3I) -> Bool {
  return a.x == b.x && a.y == b.y && a.z == b.z
}

struct V4S: Printable, Equatable {
  var x, y, z, w: F32
  init(_ x: F32 = 0, _ y: F32 = 0, _ z: F32 = 0, _ w: F32 = 0) {
    self.x = x
    self.y = y
    self.z = z
    self.w = w
  }
  init(_ v: V4S) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
    self.w = F32(v.w)
  }
  init(_ v: V4D) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
    self.w = F32(v.w)
  }
  init(_ v: V4I) {
    self.x = F32(v.x)
    self.y = F32(v.y)
    self.z = F32(v.z)
    self.w = F32(v.w)
  }
  init(_ v: V3S, _ s: F32) {
    self.x = v.x
    self.y = v.y
    self.z = v.z
    self.w = s
  }
  static let zero = V4S(0, 0, 0, 0)
  var description: String { return "V4S(\(x), \(y), \(z), \(w))" }
  var vs: V4S { return V4S(F32(x), F32(y), F32(z), F32(w)) }
  var vd: V4D { return V4D(F64(x), F64(y), F64(z), F64(w)) }
  var len: F32 { return (x.sqr + y.sqr + z.sqr + w.sqr).sqrt }
  var norm: V4S { return self / self.len }
  var clampToUnit: V4S { return V4S(clamp(x, 0, 1), clamp(y, 0, 1), clamp(z, 0, 1), clamp(w, 0, 1)) }
  var r: F32 { return x }
  var g: F32 { return y }
  var b: F32 { return z }
  var a: F32 { return w }
}

func +(a: V4S, b: V4S) -> V4S { return V4S(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w) }
func -(a: V4S, b: V4S) -> V4S { return V4S(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w) }
func *(a: V4S, b: V4S) -> V4S { return V4S(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w) }
func /(a: V4S, b: V4S) -> V4S { return V4S(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w) }
func +(a: V4S, s: F32) -> V4S { return V4S(a.x + s, a.y + s, a.z + s, a.w + s) }
func -(a: V4S, s: F32) -> V4S { return V4S(a.x - s, a.y - s, a.z - s, a.w - s) }
func *(a: V4S, s: F32) -> V4S { return V4S(a.x * s, a.y * s, a.z * s, a.w * s) }
func /(a: V4S, s: F32) -> V4S { return V4S(a.x / s, a.y / s, a.z / s, a.w / s) }

func ==(a: V4S, b: V4S) -> Bool {
  return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w
}

struct V4D: Printable, Equatable {
  var x, y, z, w: F64
  init(_ x: F64 = 0, _ y: F64 = 0, _ z: F64 = 0, _ w: F64 = 0) {
    self.x = x
    self.y = y
    self.z = z
    self.w = w
  }
  init(_ v: V4S) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
    self.w = F64(v.w)
  }
  init(_ v: V4D) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
    self.w = F64(v.w)
  }
  init(_ v: V4I) {
    self.x = F64(v.x)
    self.y = F64(v.y)
    self.z = F64(v.z)
    self.w = F64(v.w)
  }
  init(_ v: V3D, _ s: F64) {
    self.x = v.x
    self.y = v.y
    self.z = v.z
    self.w = s
  }
  static let zero = V4D(0, 0, 0, 0)
  var description: String { return "V4D(\(x), \(y), \(z), \(w))" }
  var vs: V4S { return V4S(F32(x), F32(y), F32(z), F32(w)) }
  var vd: V4D { return V4D(F64(x), F64(y), F64(z), F64(w)) }
  var len: F64 { return (x.sqr + y.sqr + z.sqr + w.sqr).sqrt }
  var norm: V4D { return self / self.len }
  var clampToUnit: V4D { return V4D(clamp(x, 0, 1), clamp(y, 0, 1), clamp(z, 0, 1), clamp(w, 0, 1)) }
  var r: F64 { return x }
  var g: F64 { return y }
  var b: F64 { return z }
  var a: F64 { return w }
}

func +(a: V4D, b: V4D) -> V4D { return V4D(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w) }
func -(a: V4D, b: V4D) -> V4D { return V4D(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w) }
func *(a: V4D, b: V4D) -> V4D { return V4D(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w) }
func /(a: V4D, b: V4D) -> V4D { return V4D(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w) }
func +(a: V4D, s: F64) -> V4D { return V4D(a.x + s, a.y + s, a.z + s, a.w + s) }
func -(a: V4D, s: F64) -> V4D { return V4D(a.x - s, a.y - s, a.z - s, a.w - s) }
func *(a: V4D, s: F64) -> V4D { return V4D(a.x * s, a.y * s, a.z * s, a.w * s) }
func /(a: V4D, s: F64) -> V4D { return V4D(a.x / s, a.y / s, a.z / s, a.w / s) }

func ==(a: V4D, b: V4D) -> Bool {
  return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w
}

struct V4I: Printable, Equatable {
  var x, y, z, w: Int
  init(_ x: Int = 0, _ y: Int = 0, _ z: Int = 0, _ w: Int = 0) {
    self.x = x
    self.y = y
    self.z = z
    self.w = w
  }
  init(_ v: V4S) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
    self.w = Int(v.w)
  }
  init(_ v: V4D) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
    self.w = Int(v.w)
  }
  init(_ v: V4I) {
    self.x = Int(v.x)
    self.y = Int(v.y)
    self.z = Int(v.z)
    self.w = Int(v.w)
  }
  init(_ v: V3I, _ s: Int) {
    self.x = v.x
    self.y = v.y
    self.z = v.z
    self.w = s
  }
  static let zero = V4I(0, 0, 0, 0)
  var description: String { return "V4I(\(x), \(y), \(z), \(w))" }
  var vs: V4S { return V4S(F32(x), F32(y), F32(z), F32(w)) }
  var vd: V4D { return V4D(F64(x), F64(y), F64(z), F64(w)) }
  var len: Flt { return (Flt(x).sqr + Flt(y).sqr + Flt(z).sqr + Flt(w).sqr).sqrt }
  var clampToUnit: V4I { return V4I(clamp(x, 0, 1), clamp(y, 0, 1), clamp(z, 0, 1), clamp(w, 0, 1)) }
  var r: Int { return x }
  var g: Int { return y }
  var b: Int { return z }
  var a: Int { return w }
}

func +(a: V4I, b: V4I) -> V4I { return V4I(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w) }
func -(a: V4I, b: V4I) -> V4I { return V4I(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w) }
func *(a: V4I, b: V4I) -> V4I { return V4I(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w) }
func /(a: V4I, b: V4I) -> V4I { return V4I(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w) }
func +(a: V4I, s: Int) -> V4I { return V4I(a.x + s, a.y + s, a.z + s, a.w + s) }
func -(a: V4I, s: Int) -> V4I { return V4I(a.x - s, a.y - s, a.z - s, a.w - s) }
func *(a: V4I, s: Int) -> V4I { return V4I(a.x * s, a.y * s, a.z * s, a.w * s) }
func /(a: V4I, s: Int) -> V4I { return V4I(a.x / s, a.y / s, a.z / s, a.w / s) }

func ==(a: V4I, b: V4I) -> Bool {
  return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w
}

struct M2F32: Printable {
  var m00, m01, m10, m11: F32
  init(_ m00: F32, _ m01: F32, _ m10: F32, _ m11: F32) {
    self.m00 = m00
    self.m01 = m01
    self.m10 = m10
    self.m11 = m11
  }
  init(_ c0: V2S, _ c1: V2S) {
    self.init(c0.x, c0.y, c1.x, c1.y)
  }
  var description: String { return "M2F32(\(m00), \(m01), \(m10), \(m11))" }
  var c0: V2S { return V2S(m00, m01) }
  var c1: V2S { return V2S(m10, m11) }
  var r0: V2S { return V2S(m00, m10) }
  var r1: V2S { return V2S(m01, m11) }
}

let M2F32Zero = M2F32(0, 0, 0, 0)
let M2F32Identity = M2F32(1, 0, 0, 1)

func +(a: M2F32, b: M2F32) -> M2F32 { return M2F32(a.m00 + b.m00, a.m01 + b.m01, a.m10 + b.m10, a.m11 + b.m11) }
func -(a: M2F32, b: M2F32) -> M2F32 { return M2F32(a.m00 - b.m00, a.m01 - b.m01, a.m10 - b.m10, a.m11 - b.m11) }
func *(a: M2F32, s: F32) -> M2F32 { return M2F32(a.m00 * s, a.m01 * s, a.m10 * s, a.m11 * s) }
func /(a: M2F32, s: F32) -> M2F32 { return M2F32(a.m00 / s, a.m01 / s, a.m10 / s, a.m11 / s) }


func M2F32Scale(x: F32, y: F32) -> M2F32 { return M2F32(x, 0, 0, y) }
struct M2F64: Printable {
  var m00, m01, m10, m11: F64
  init(_ m00: F64, _ m01: F64, _ m10: F64, _ m11: F64) {
    self.m00 = m00
    self.m01 = m01
    self.m10 = m10
    self.m11 = m11
  }
  init(_ c0: V2D, _ c1: V2D) {
    self.init(c0.x, c0.y, c1.x, c1.y)
  }
  var description: String { return "M2F64(\(m00), \(m01), \(m10), \(m11))" }
  var c0: V2D { return V2D(m00, m01) }
  var c1: V2D { return V2D(m10, m11) }
  var r0: V2D { return V2D(m00, m10) }
  var r1: V2D { return V2D(m01, m11) }
}

let M2F64Zero = M2F64(0, 0, 0, 0)
let M2F64Identity = M2F64(1, 0, 0, 1)

func +(a: M2F64, b: M2F64) -> M2F64 { return M2F64(a.m00 + b.m00, a.m01 + b.m01, a.m10 + b.m10, a.m11 + b.m11) }
func -(a: M2F64, b: M2F64) -> M2F64 { return M2F64(a.m00 - b.m00, a.m01 - b.m01, a.m10 - b.m10, a.m11 - b.m11) }
func *(a: M2F64, s: F64) -> M2F64 { return M2F64(a.m00 * s, a.m01 * s, a.m10 * s, a.m11 * s) }
func /(a: M2F64, s: F64) -> M2F64 { return M2F64(a.m00 / s, a.m01 / s, a.m10 / s, a.m11 / s) }


func M2F64Scale(x: F64, y: F64) -> M2F64 { return M2F64(x, 0, 0, y) }
struct M2Int: Printable {
  var m00, m01, m10, m11: Int
  init(_ m00: Int, _ m01: Int, _ m10: Int, _ m11: Int) {
    self.m00 = m00
    self.m01 = m01
    self.m10 = m10
    self.m11 = m11
  }
  init(_ c0: V2I, _ c1: V2I) {
    self.init(c0.x, c0.y, c1.x, c1.y)
  }
  var description: String { return "M2Int(\(m00), \(m01), \(m10), \(m11))" }
  var c0: V2I { return V2I(m00, m01) }
  var c1: V2I { return V2I(m10, m11) }
  var r0: V2I { return V2I(m00, m10) }
  var r1: V2I { return V2I(m01, m11) }
}

let M2IntZero = M2Int(0, 0, 0, 0)
let M2IntIdentity = M2Int(1, 0, 0, 1)

func +(a: M2Int, b: M2Int) -> M2Int { return M2Int(a.m00 + b.m00, a.m01 + b.m01, a.m10 + b.m10, a.m11 + b.m11) }
func -(a: M2Int, b: M2Int) -> M2Int { return M2Int(a.m00 - b.m00, a.m01 - b.m01, a.m10 - b.m10, a.m11 - b.m11) }
func *(a: M2Int, s: Int) -> M2Int { return M2Int(a.m00 * s, a.m01 * s, a.m10 * s, a.m11 * s) }
func /(a: M2Int, s: Int) -> M2Int { return M2Int(a.m00 / s, a.m01 / s, a.m10 / s, a.m11 / s) }


func M2IntScale(x: Int, y: Int) -> M2Int { return M2Int(x, 0, 0, y) }
struct M3F32: Printable {
  var m00, m01, m02, m10, m11, m12, m20, m21, m22: F32
  init(_ m00: F32, _ m01: F32, _ m02: F32, _ m10: F32, _ m11: F32, _ m12: F32, _ m20: F32, _ m21: F32, _ m22: F32) {
    self.m00 = m00
    self.m01 = m01
    self.m02 = m02
    self.m10 = m10
    self.m11 = m11
    self.m12 = m12
    self.m20 = m20
    self.m21 = m21
    self.m22 = m22
  }
  init(_ c0: V3S, _ c1: V3S, _ c2: V3S) {
    self.init(c0.x, c0.y, c0.z, c1.x, c1.y, c1.z, c2.x, c2.y, c2.z)
  }
  var description: String { return "M3F32(\(m00), \(m01), \(m02), \(m10), \(m11), \(m12), \(m20), \(m21), \(m22))" }
  var c0: V3S { return V3S(m00, m01, m02) }
  var c1: V3S { return V3S(m10, m11, m12) }
  var c2: V3S { return V3S(m20, m21, m22) }
  var r0: V3S { return V3S(m00, m10, m20) }
  var r1: V3S { return V3S(m01, m11, m21) }
  var r2: V3S { return V3S(m02, m12, m22) }
}

let M3F32Zero = M3F32(0, 0, 0, 0, 0, 0, 0, 0, 0)
let M3F32Identity = M3F32(1, 0, 0, 0, 1, 0, 0, 0, 1)

func +(a: M3F32, b: M3F32) -> M3F32 { return M3F32(a.m00 + b.m00, a.m01 + b.m01, a.m02 + b.m02, a.m10 + b.m10, a.m11 + b.m11, a.m12 + b.m12, a.m20 + b.m20, a.m21 + b.m21, a.m22 + b.m22) }
func -(a: M3F32, b: M3F32) -> M3F32 { return M3F32(a.m00 - b.m00, a.m01 - b.m01, a.m02 - b.m02, a.m10 - b.m10, a.m11 - b.m11, a.m12 - b.m12, a.m20 - b.m20, a.m21 - b.m21, a.m22 - b.m22) }
func *(a: M3F32, s: F32) -> M3F32 { return M3F32(a.m00 * s, a.m01 * s, a.m02 * s, a.m10 * s, a.m11 * s, a.m12 * s, a.m20 * s, a.m21 * s, a.m22 * s) }
func /(a: M3F32, s: F32) -> M3F32 { return M3F32(a.m00 / s, a.m01 / s, a.m02 / s, a.m10 / s, a.m11 / s, a.m12 / s, a.m20 / s, a.m21 / s, a.m22 / s) }


func M3F32Scale(x: F32, y: F32, z: F32) -> M3F32 { return M3F32(x, 0, 0, 0, y, 0, 0, 0, z) }
struct M3F64: Printable {
  var m00, m01, m02, m10, m11, m12, m20, m21, m22: F64
  init(_ m00: F64, _ m01: F64, _ m02: F64, _ m10: F64, _ m11: F64, _ m12: F64, _ m20: F64, _ m21: F64, _ m22: F64) {
    self.m00 = m00
    self.m01 = m01
    self.m02 = m02
    self.m10 = m10
    self.m11 = m11
    self.m12 = m12
    self.m20 = m20
    self.m21 = m21
    self.m22 = m22
  }
  init(_ c0: V3D, _ c1: V3D, _ c2: V3D) {
    self.init(c0.x, c0.y, c0.z, c1.x, c1.y, c1.z, c2.x, c2.y, c2.z)
  }
  var description: String { return "M3F64(\(m00), \(m01), \(m02), \(m10), \(m11), \(m12), \(m20), \(m21), \(m22))" }
  var c0: V3D { return V3D(m00, m01, m02) }
  var c1: V3D { return V3D(m10, m11, m12) }
  var c2: V3D { return V3D(m20, m21, m22) }
  var r0: V3D { return V3D(m00, m10, m20) }
  var r1: V3D { return V3D(m01, m11, m21) }
  var r2: V3D { return V3D(m02, m12, m22) }
}

let M3F64Zero = M3F64(0, 0, 0, 0, 0, 0, 0, 0, 0)
let M3F64Identity = M3F64(1, 0, 0, 0, 1, 0, 0, 0, 1)

func +(a: M3F64, b: M3F64) -> M3F64 { return M3F64(a.m00 + b.m00, a.m01 + b.m01, a.m02 + b.m02, a.m10 + b.m10, a.m11 + b.m11, a.m12 + b.m12, a.m20 + b.m20, a.m21 + b.m21, a.m22 + b.m22) }
func -(a: M3F64, b: M3F64) -> M3F64 { return M3F64(a.m00 - b.m00, a.m01 - b.m01, a.m02 - b.m02, a.m10 - b.m10, a.m11 - b.m11, a.m12 - b.m12, a.m20 - b.m20, a.m21 - b.m21, a.m22 - b.m22) }
func *(a: M3F64, s: F64) -> M3F64 { return M3F64(a.m00 * s, a.m01 * s, a.m02 * s, a.m10 * s, a.m11 * s, a.m12 * s, a.m20 * s, a.m21 * s, a.m22 * s) }
func /(a: M3F64, s: F64) -> M3F64 { return M3F64(a.m00 / s, a.m01 / s, a.m02 / s, a.m10 / s, a.m11 / s, a.m12 / s, a.m20 / s, a.m21 / s, a.m22 / s) }


func M3F64Scale(x: F64, y: F64, z: F64) -> M3F64 { return M3F64(x, 0, 0, 0, y, 0, 0, 0, z) }
struct M3Int: Printable {
  var m00, m01, m02, m10, m11, m12, m20, m21, m22: Int
  init(_ m00: Int, _ m01: Int, _ m02: Int, _ m10: Int, _ m11: Int, _ m12: Int, _ m20: Int, _ m21: Int, _ m22: Int) {
    self.m00 = m00
    self.m01 = m01
    self.m02 = m02
    self.m10 = m10
    self.m11 = m11
    self.m12 = m12
    self.m20 = m20
    self.m21 = m21
    self.m22 = m22
  }
  init(_ c0: V3I, _ c1: V3I, _ c2: V3I) {
    self.init(c0.x, c0.y, c0.z, c1.x, c1.y, c1.z, c2.x, c2.y, c2.z)
  }
  var description: String { return "M3Int(\(m00), \(m01), \(m02), \(m10), \(m11), \(m12), \(m20), \(m21), \(m22))" }
  var c0: V3I { return V3I(m00, m01, m02) }
  var c1: V3I { return V3I(m10, m11, m12) }
  var c2: V3I { return V3I(m20, m21, m22) }
  var r0: V3I { return V3I(m00, m10, m20) }
  var r1: V3I { return V3I(m01, m11, m21) }
  var r2: V3I { return V3I(m02, m12, m22) }
}

let M3IntZero = M3Int(0, 0, 0, 0, 0, 0, 0, 0, 0)
let M3IntIdentity = M3Int(1, 0, 0, 0, 1, 0, 0, 0, 1)

func +(a: M3Int, b: M3Int) -> M3Int { return M3Int(a.m00 + b.m00, a.m01 + b.m01, a.m02 + b.m02, a.m10 + b.m10, a.m11 + b.m11, a.m12 + b.m12, a.m20 + b.m20, a.m21 + b.m21, a.m22 + b.m22) }
func -(a: M3Int, b: M3Int) -> M3Int { return M3Int(a.m00 - b.m00, a.m01 - b.m01, a.m02 - b.m02, a.m10 - b.m10, a.m11 - b.m11, a.m12 - b.m12, a.m20 - b.m20, a.m21 - b.m21, a.m22 - b.m22) }
func *(a: M3Int, s: Int) -> M3Int { return M3Int(a.m00 * s, a.m01 * s, a.m02 * s, a.m10 * s, a.m11 * s, a.m12 * s, a.m20 * s, a.m21 * s, a.m22 * s) }
func /(a: M3Int, s: Int) -> M3Int { return M3Int(a.m00 / s, a.m01 / s, a.m02 / s, a.m10 / s, a.m11 / s, a.m12 / s, a.m20 / s, a.m21 / s, a.m22 / s) }


func M3IntScale(x: Int, y: Int, z: Int) -> M3Int { return M3Int(x, 0, 0, 0, y, 0, 0, 0, z) }
struct M4F32: Printable {
  var m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: F32
  init(_ m00: F32, _ m01: F32, _ m02: F32, _ m03: F32, _ m10: F32, _ m11: F32, _ m12: F32, _ m13: F32, _ m20: F32, _ m21: F32, _ m22: F32, _ m23: F32, _ m30: F32, _ m31: F32, _ m32: F32, _ m33: F32) {
    self.m00 = m00
    self.m01 = m01
    self.m02 = m02
    self.m03 = m03
    self.m10 = m10
    self.m11 = m11
    self.m12 = m12
    self.m13 = m13
    self.m20 = m20
    self.m21 = m21
    self.m22 = m22
    self.m23 = m23
    self.m30 = m30
    self.m31 = m31
    self.m32 = m32
    self.m33 = m33
  }
  init(_ c0: V4S, _ c1: V4S, _ c2: V4S, _ c3: V4S) {
    self.init(c0.x, c0.y, c0.z, c0.w, c1.x, c1.y, c1.z, c1.w, c2.x, c2.y, c2.z, c2.w, c3.x, c3.y, c3.z, c3.w)
  }
  var description: String { return "M4F32(\(m00), \(m01), \(m02), \(m03), \(m10), \(m11), \(m12), \(m13), \(m20), \(m21), \(m22), \(m23), \(m30), \(m31), \(m32), \(m33))" }
  var c0: V4S { return V4S(m00, m01, m02, m03) }
  var c1: V4S { return V4S(m10, m11, m12, m13) }
  var c2: V4S { return V4S(m20, m21, m22, m23) }
  var c3: V4S { return V4S(m30, m31, m32, m33) }
  var r0: V4S { return V4S(m00, m10, m20, m30) }
  var r1: V4S { return V4S(m01, m11, m21, m31) }
  var r2: V4S { return V4S(m02, m12, m22, m32) }
  var r3: V4S { return V4S(m03, m13, m23, m33) }
}

let M4F32Zero = M4F32(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
let M4F32Identity = M4F32(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)

func +(a: M4F32, b: M4F32) -> M4F32 { return M4F32(a.m00 + b.m00, a.m01 + b.m01, a.m02 + b.m02, a.m03 + b.m03, a.m10 + b.m10, a.m11 + b.m11, a.m12 + b.m12, a.m13 + b.m13, a.m20 + b.m20, a.m21 + b.m21, a.m22 + b.m22, a.m23 + b.m23, a.m30 + b.m30, a.m31 + b.m31, a.m32 + b.m32, a.m33 + b.m33) }
func -(a: M4F32, b: M4F32) -> M4F32 { return M4F32(a.m00 - b.m00, a.m01 - b.m01, a.m02 - b.m02, a.m03 - b.m03, a.m10 - b.m10, a.m11 - b.m11, a.m12 - b.m12, a.m13 - b.m13, a.m20 - b.m20, a.m21 - b.m21, a.m22 - b.m22, a.m23 - b.m23, a.m30 - b.m30, a.m31 - b.m31, a.m32 - b.m32, a.m33 - b.m33) }
func *(a: M4F32, s: F32) -> M4F32 { return M4F32(a.m00 * s, a.m01 * s, a.m02 * s, a.m03 * s, a.m10 * s, a.m11 * s, a.m12 * s, a.m13 * s, a.m20 * s, a.m21 * s, a.m22 * s, a.m23 * s, a.m30 * s, a.m31 * s, a.m32 * s, a.m33 * s) }
func /(a: M4F32, s: F32) -> M4F32 { return M4F32(a.m00 / s, a.m01 / s, a.m02 / s, a.m03 / s, a.m10 / s, a.m11 / s, a.m12 / s, a.m13 / s, a.m20 / s, a.m21 / s, a.m22 / s, a.m23 / s, a.m30 / s, a.m31 / s, a.m32 / s, a.m33 / s) }


func M4F32Scale(x: F32, y: F32, z: F32, w: F32) -> M4F32 { return M4F32(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, w) }
struct M4F64: Printable {
  var m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: F64
  init(_ m00: F64, _ m01: F64, _ m02: F64, _ m03: F64, _ m10: F64, _ m11: F64, _ m12: F64, _ m13: F64, _ m20: F64, _ m21: F64, _ m22: F64, _ m23: F64, _ m30: F64, _ m31: F64, _ m32: F64, _ m33: F64) {
    self.m00 = m00
    self.m01 = m01
    self.m02 = m02
    self.m03 = m03
    self.m10 = m10
    self.m11 = m11
    self.m12 = m12
    self.m13 = m13
    self.m20 = m20
    self.m21 = m21
    self.m22 = m22
    self.m23 = m23
    self.m30 = m30
    self.m31 = m31
    self.m32 = m32
    self.m33 = m33
  }
  init(_ c0: V4D, _ c1: V4D, _ c2: V4D, _ c3: V4D) {
    self.init(c0.x, c0.y, c0.z, c0.w, c1.x, c1.y, c1.z, c1.w, c2.x, c2.y, c2.z, c2.w, c3.x, c3.y, c3.z, c3.w)
  }
  var description: String { return "M4F64(\(m00), \(m01), \(m02), \(m03), \(m10), \(m11), \(m12), \(m13), \(m20), \(m21), \(m22), \(m23), \(m30), \(m31), \(m32), \(m33))" }
  var c0: V4D { return V4D(m00, m01, m02, m03) }
  var c1: V4D { return V4D(m10, m11, m12, m13) }
  var c2: V4D { return V4D(m20, m21, m22, m23) }
  var c3: V4D { return V4D(m30, m31, m32, m33) }
  var r0: V4D { return V4D(m00, m10, m20, m30) }
  var r1: V4D { return V4D(m01, m11, m21, m31) }
  var r2: V4D { return V4D(m02, m12, m22, m32) }
  var r3: V4D { return V4D(m03, m13, m23, m33) }
}

let M4F64Zero = M4F64(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
let M4F64Identity = M4F64(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)

func +(a: M4F64, b: M4F64) -> M4F64 { return M4F64(a.m00 + b.m00, a.m01 + b.m01, a.m02 + b.m02, a.m03 + b.m03, a.m10 + b.m10, a.m11 + b.m11, a.m12 + b.m12, a.m13 + b.m13, a.m20 + b.m20, a.m21 + b.m21, a.m22 + b.m22, a.m23 + b.m23, a.m30 + b.m30, a.m31 + b.m31, a.m32 + b.m32, a.m33 + b.m33) }
func -(a: M4F64, b: M4F64) -> M4F64 { return M4F64(a.m00 - b.m00, a.m01 - b.m01, a.m02 - b.m02, a.m03 - b.m03, a.m10 - b.m10, a.m11 - b.m11, a.m12 - b.m12, a.m13 - b.m13, a.m20 - b.m20, a.m21 - b.m21, a.m22 - b.m22, a.m23 - b.m23, a.m30 - b.m30, a.m31 - b.m31, a.m32 - b.m32, a.m33 - b.m33) }
func *(a: M4F64, s: F64) -> M4F64 { return M4F64(a.m00 * s, a.m01 * s, a.m02 * s, a.m03 * s, a.m10 * s, a.m11 * s, a.m12 * s, a.m13 * s, a.m20 * s, a.m21 * s, a.m22 * s, a.m23 * s, a.m30 * s, a.m31 * s, a.m32 * s, a.m33 * s) }
func /(a: M4F64, s: F64) -> M4F64 { return M4F64(a.m00 / s, a.m01 / s, a.m02 / s, a.m03 / s, a.m10 / s, a.m11 / s, a.m12 / s, a.m13 / s, a.m20 / s, a.m21 / s, a.m22 / s, a.m23 / s, a.m30 / s, a.m31 / s, a.m32 / s, a.m33 / s) }


func M4F64Scale(x: F64, y: F64, z: F64, w: F64) -> M4F64 { return M4F64(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, w) }
struct M4Int: Printable {
  var m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33: Int
  init(_ m00: Int, _ m01: Int, _ m02: Int, _ m03: Int, _ m10: Int, _ m11: Int, _ m12: Int, _ m13: Int, _ m20: Int, _ m21: Int, _ m22: Int, _ m23: Int, _ m30: Int, _ m31: Int, _ m32: Int, _ m33: Int) {
    self.m00 = m00
    self.m01 = m01
    self.m02 = m02
    self.m03 = m03
    self.m10 = m10
    self.m11 = m11
    self.m12 = m12
    self.m13 = m13
    self.m20 = m20
    self.m21 = m21
    self.m22 = m22
    self.m23 = m23
    self.m30 = m30
    self.m31 = m31
    self.m32 = m32
    self.m33 = m33
  }
  init(_ c0: V4I, _ c1: V4I, _ c2: V4I, _ c3: V4I) {
    self.init(c0.x, c0.y, c0.z, c0.w, c1.x, c1.y, c1.z, c1.w, c2.x, c2.y, c2.z, c2.w, c3.x, c3.y, c3.z, c3.w)
  }
  var description: String { return "M4Int(\(m00), \(m01), \(m02), \(m03), \(m10), \(m11), \(m12), \(m13), \(m20), \(m21), \(m22), \(m23), \(m30), \(m31), \(m32), \(m33))" }
  var c0: V4I { return V4I(m00, m01, m02, m03) }
  var c1: V4I { return V4I(m10, m11, m12, m13) }
  var c2: V4I { return V4I(m20, m21, m22, m23) }
  var c3: V4I { return V4I(m30, m31, m32, m33) }
  var r0: V4I { return V4I(m00, m10, m20, m30) }
  var r1: V4I { return V4I(m01, m11, m21, m31) }
  var r2: V4I { return V4I(m02, m12, m22, m32) }
  var r3: V4I { return V4I(m03, m13, m23, m33) }
}

let M4IntZero = M4Int(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
let M4IntIdentity = M4Int(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)

func +(a: M4Int, b: M4Int) -> M4Int { return M4Int(a.m00 + b.m00, a.m01 + b.m01, a.m02 + b.m02, a.m03 + b.m03, a.m10 + b.m10, a.m11 + b.m11, a.m12 + b.m12, a.m13 + b.m13, a.m20 + b.m20, a.m21 + b.m21, a.m22 + b.m22, a.m23 + b.m23, a.m30 + b.m30, a.m31 + b.m31, a.m32 + b.m32, a.m33 + b.m33) }
func -(a: M4Int, b: M4Int) -> M4Int { return M4Int(a.m00 - b.m00, a.m01 - b.m01, a.m02 - b.m02, a.m03 - b.m03, a.m10 - b.m10, a.m11 - b.m11, a.m12 - b.m12, a.m13 - b.m13, a.m20 - b.m20, a.m21 - b.m21, a.m22 - b.m22, a.m23 - b.m23, a.m30 - b.m30, a.m31 - b.m31, a.m32 - b.m32, a.m33 - b.m33) }
func *(a: M4Int, s: Int) -> M4Int { return M4Int(a.m00 * s, a.m01 * s, a.m02 * s, a.m03 * s, a.m10 * s, a.m11 * s, a.m12 * s, a.m13 * s, a.m20 * s, a.m21 * s, a.m22 * s, a.m23 * s, a.m30 * s, a.m31 * s, a.m32 * s, a.m33 * s) }
func /(a: M4Int, s: Int) -> M4Int { return M4Int(a.m00 / s, a.m01 / s, a.m02 / s, a.m03 / s, a.m10 / s, a.m11 / s, a.m12 / s, a.m13 / s, a.m20 / s, a.m21 / s, a.m22 / s, a.m23 / s, a.m30 / s, a.m31 / s, a.m32 / s, a.m33 / s) }


func M4IntScale(x: Int, y: Int, z: Int, w: Int) -> M4Int { return M4Int(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, w) }
