// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import SceneKit

typealias V3 = SCNVector3
typealias V4 = SCNVector4


extension V3: Printable {

  init(_ x: Flt, _ y: Flt, _ z: Flt) {
    self.x = x
    self.y = y
    self.z = z
  }

  init(_ v: V2, _ z: Flt = 0) {
    self.x = v.x
    self.y = v.y
    self.z = z
  }
  
  public var description: String { return "V3(\(x), \(y), \(z))" }
  var len: Flt { return (x.sqr + y.sqr + z.sqr).sqrt }
  var norm: V3 { return self / self.len }
  var clampToUnit: V3 { return V3(clamp(x, 0, 1), clamp(y, 0, 1), clamp(z, 0, 1)) }
  var v32: V3F32 { return V3F32(F32(x), F32(y), F32(z)); }
}


func +(a: V3, b: V3) -> V3 { return V3(a.x + b.x, a.y + b.y, a.z + b.z) }
func -(a: V3, b: V3) -> V3 { return V3(a.x - b.x, a.y - b.y, a.z - b.z) }
func *(a: V3, b: V3) -> V3 { return V3(a.x * b.x, a.y * b.y, a.z * b.z) }
func /(a: V3, b: V3) -> V3 { return V3(a.x / b.x, a.y / b.y, a.z / b.z) }
func +(a: V3, s: Flt) -> V3 { return V3(a.x + s, a.y + s, a.z + s) }
func -(a: V3, s: Flt) -> V3 { return V3(a.x - s, a.y - s, a.z - s) }
func *(a: V3, s: Flt) -> V3 { return V3(a.x * s, a.y * s, a.z * s) }
func /(a: V3, s: Flt) -> V3 { return V3(a.x / s, a.y / s, a.z / s) }


extension V4: Printable {

  init(_ x: Flt, _ y: Flt, _ z: Flt, _ w: Flt) {
    self.x = x
    self.y = y
    self.z = z
    self.w = w
  }
  
  init(_ v: V3, _ w: Flt) {
    self.x = v.x
    self.y = v.y
    self.z = v.z
    self.w = w
  }
  
  public var description: String { return "V4(\(x), \(y), \(z), \(w))" }
  var len: Flt { return (x.sqr + y.sqr + z.sqr + w.sqr).sqrt }
  var norm: V4 { return self / self.len }
  var clampToUnit: V4 { return V4(clamp(x, 0, 1), clamp(y, 0, 1), clamp(z, 0, 1), clamp(w, 0, 1)) }
  var v32: V4F32 { return V4F32(F32(x), F32(y), F32(z), F32(w)); }
}

func +(a: V4, b: V4) -> V4 { return V4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w) }
func -(a: V4, b: V4) -> V4 { return V4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w) }
func *(a: V4, b: V4) -> V4 { return V4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w) }
func /(a: V4, b: V4) -> V4 { return V4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w) }
func +(a: V4, s: Flt) -> V4 { return V4(a.x + s, a.y + s, a.z + s, a.w + s) }
func -(a: V4, s: Flt) -> V4 { return V4(a.x - s, a.y - s, a.z - s, a.w - s) }
func *(a: V4, s: Flt) -> V4 { return V4(a.x * s, a.y * s, a.z * s, a.w * s) }
func /(a: V4, s: Flt) -> V4 { return V4(a.x / s, a.y / s, a.z / s, a.w / s) }


