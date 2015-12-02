func sortQuadIndices(a: Int, _ b: Int, _ c: Int, _ d: Int, cmp: (Int, Int) -> Bool) -> (Int, Int, Int, Int) {
  let ab = cmp(a, b) ? (0, 1) : (1, 0)
  let cd = cmp(c, d) ? (2, 3) : (3, 2)
  var r0, r1, r2, r3: Int
  if cmp(ab.0, cd.0) {
    r0 = ab.0
    if cmp(ab.1, cd.0) {
      r1 = ab.1
      r2 = cd.0 // cd already sorted.
      r3 = cd.1
    } else {
      r1 = cd.0
      if cmp(ab.1, cd.1) {
        r2 = ab.1
        r3 = cd.1
      } else {
        r2 = cd.1
        r3 = ab.1
      }
    }
  } else { // cd.0 < ab.0.
    r0 = cd.0
    if cmp(cd.1, ab.0) {
      r1 = cd.1
      r2 = ab.0 // ab already sorted.
      r3 = ab.1
    } else {
      r1 = ab.0
      if cmp(cd.1, ab.1) {
        r2 = cd.1
        r3 = ab.1
      } else {
        r2 = ab.1
        r3 = cd.1
      }
    }
  }
  return (r0, r1, r2, r3)
}

