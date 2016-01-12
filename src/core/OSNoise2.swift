
import Darwin

class OSNoise2 {

  typealias Flt = Double

  static let stretchFactor: Flt = (1.0 / 3.0.sqrt - 1.0 ) / 2.0
  static let squishFactor: Flt  = (3.0.sqrt - 1.0) / 2.0
  static let normFactor: Flt = 47.0

  // The vector gradients approximate the directions to the vertices of an octagon from the center.
  static let gradients2D: [Int] = [
     5,  2,    2,  5,
    -5,  2,   -2,  5,
     5, -2,    2, -5,
    -5, -2,   -2, -5,
  ]

  let perm: [Int]

  init(seed: Int = 0x12345678) {
    func next(i: Int) -> Int {
      // TODO: find the explanation for these constants.
      return i &* 6364136223846793005 &+ 1442695040888963407
    }
    let size = 256
    var s = seed
    s = next(s)
    s = next(s)
    s = next(s)
    var source = Array(0..<size)
    var perm = Array(count: size, repeatedValue: 0)
    for j in 0..<size {
      let i = size - (1 + j)
      s = next(s)
      var r = (s + 31) % (i + 1)
      if r < 0 {
        r += i + 1
      }
      perm[i] = source[r]
      source[r] = source[i]
    }
    self.perm = perm
  }

  @warn_unused_result
  func extrapolate2(xsb xsb: Int, ysb: Int, dx: Flt, dy: Flt) -> Flt {
    let index = perm[(perm[xsb & 0xFF] + ysb) & 0xFF] & 0x0E
    return Flt(OSNoise2.gradients2D[index]) * dx + Flt(OSNoise2.gradients2D[index + 1]) * dy
  }

  @warn_unused_result
  func fastFloor(x: Flt) -> Int {
    let i = Int(x)
    return x < Flt(i) ? i - 1 : i
  }


  @warn_unused_result
  func val(x: Flt, _ y: Flt) -> Flt {

    // Place input coordinates onto grid.
    let stretchOffset = (x + y) * OSNoise2.stretchFactor
    let xs = x + stretchOffset
    let ys = y + stretchOffset

    // Floor to get grid coordinates of rhombus (stretched square) super-cell origin.
    var xsb = fastFloor(xs)
    var ysb = fastFloor(ys)

    // Skew out to get actual coordinates of rhombus origin. We'll need these later.
    let squishOffset = Flt(xsb + ysb) * OSNoise2.squishFactor
    let xb = Flt(xsb) + squishOffset
    let yb = Flt(ysb) + squishOffset

    // Compute grid coordinates relative to rhombus origin.
    let xins = xs - Flt(xsb)
    let yins = ys - Flt(ysb)

    // Sum those together to get a value that determines which region we're in.
    let inSum = xins + yins

    // Positions relative to origin point.
    var dx0 = x - xb
    var dy0 = y - yb

    var value: Flt = 0

    // Contribution (1,0).
    let dx1 = dx0 - 1 - OSNoise2.squishFactor
    let dy1 = dy0 - 0 - OSNoise2.squishFactor
    var attn1 = 2 - dx1 * dx1 - dy1 * dy1
    if (attn1 > 0) {
      attn1 *= attn1
      value += attn1 * attn1 * extrapolate2(xsb: xsb + 1, ysb: ysb + 0, dx: dx1, dy: dy1)
    }

    // Contribution (0,1)
    let dx2 = dx0 - 0 - OSNoise2.squishFactor
    let dy2 = dy0 - 1 - OSNoise2.squishFactor
    var attn2 = 2 - dx2 * dx2 - dy2 * dy2
    if (attn2 > 0) {
      attn2 *= attn2
      value += attn2 * attn2 * extrapolate2(xsb: xsb + 0, ysb: ysb + 1, dx: dx2, dy: dy2)
    }

    var dx_ext, dy_ext: Flt
    var xsv_ext, ysv_ext: Int

    if (inSum <= 1) { // We're inside the triangle (2-Simplex) at (0,0).
      let zins = 1 - inSum
      if (zins > xins || zins > yins) { // (0,0) is one of the closest two triangular vertices.
        if (xins > yins) {
          xsv_ext = xsb + 1
          ysv_ext = ysb - 1
          dx_ext = dx0 - 1
          dy_ext = dy0 + 1
        } else {
          xsv_ext = xsb - 1
          ysv_ext = ysb + 1
          dx_ext = dx0 + 1
          dy_ext = dy0 - 1
        }
      } else { // (1,0) and (0,1) are the closest two vertices.
        xsv_ext = xsb + 1
        ysv_ext = ysb + 1
        dx_ext = dx0 - 1 - 2 * OSNoise2.squishFactor
        dy_ext = dy0 - 1 - 2 * OSNoise2.squishFactor
      }
    } else { // We're inside the triangle (2-Simplex) at (1,1).
      let zins = 2 - inSum
      if (zins < xins || zins < yins) { // (0,0) is one of the closest two triangular vertices.
        if (xins > yins) {
          xsv_ext = xsb + 2
          ysv_ext = ysb + 0
          dx_ext = dx0 - 2 - 2 * OSNoise2.squishFactor
          dy_ext = dy0 + 0 - 2 * OSNoise2.squishFactor
        } else {
          xsv_ext = xsb + 0
          ysv_ext = ysb + 2
          dx_ext = dx0 + 0 - 2 * OSNoise2.squishFactor
          dy_ext = dy0 - 2 - 2 * OSNoise2.squishFactor
        }
      } else { // (1,0) and (0,1) are the closest two vertices.
        dx_ext = dx0
        dy_ext = dy0
        xsv_ext = xsb
        ysv_ext = ysb
      }
      xsb += 1
      ysb += 1
      dx0 = dx0 - 1 - 2 * OSNoise2.squishFactor
      dy0 = dy0 - 1 - 2 * OSNoise2.squishFactor
    }

    // Contribution (0,0) or (1,1).
    var attn0 = 2 - dx0 * dx0 - dy0 * dy0
    if (attn0 > 0) {
      attn0 *= attn0
      value += attn0 * attn0 * extrapolate2(xsb: xsb, ysb: ysb, dx: dx0, dy: dy0)
    }

    // Extra Vertex.
    var attn_ext = 2 - dx_ext * dx_ext - dy_ext * dy_ext
    if (attn_ext > 0) {
      attn_ext *= attn_ext
      value += attn_ext * attn_ext * extrapolate2(xsb: xsv_ext, ysb: ysv_ext, dx: dx_ext, dy: dy_ext)
    }

    return value / OSNoise2.normFactor
  }

  @warn_unused_result
  func multiVal(x: Flt, _ y: Flt, octaveWeights: [Flt]) -> Flt {
    let totalWeight = sum(octaveWeights)
    var v = 0.0
    for (i, weight) in octaveWeights.enumerate() {
      let scale = Flt(1 << i)
      v += val(x * scale, y * scale) * weight
    }
    return v / totalWeight
  }
}
