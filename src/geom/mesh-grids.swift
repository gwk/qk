// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import CoreGraphics


func gridCage(divisions: Int, barRatio: Flt = 1 / 16) -> Mesh {
  let m = Mesh()
  let steps = divisions + 1
  let steps_f = Flt(steps)
  for i in 0...steps {
    let t: Flt = Flt(i * 2) / steps_f - 1
    let pad: Flt = barRatio / (steps_f * 2)
    let l = t - pad
    let h = t + pad
    
    m.addQuad( // back x.
      V3(-1, l, -1),
      V3( 1, l, -1),
      V3( 1, h, -1),
      V3(-1, h, -1));
    m.addQuad( // front x.
      V3(-1, l,  1),
      V3(-1, h,  1),
      V3( 1, h,  1),
      V3( 1, l,  1));
    
    m.addQuad( // bottom x.
      V3(-1, -1,  l),
      V3(-1, -1,  h),
      V3( 1, -1,  h),
      V3( 1, -1,  l));
    m.addQuad( // top x.
      V3(-1,  1,  l),
      V3( 1,  1,  l),
      V3( 1,  1,  h),
      V3(-1,  1,  h));
    
    m.addQuad( // back y.
      V3( l, -1, -1),
      V3( h, -1, -1),
      V3( h,  1, -1),
      V3( l,  1, -1));
    m.addQuad( // front y.
      V3( l, -1,  1),
      V3( l,  1,  1),
      V3( h,  1,  1),
      V3( h, -1,  1));
    m.addQuad( // left y.
      V3(-1, -1,  l),
      V3(-1,  1,  l),
      V3(-1,  1,  h),
      V3(-1, -1,  h));
    m.addQuad( // right y.
      V3( 1, -1,  l),
      V3( 1, -1,  h),
      V3( 1,  1,  h),
      V3( 1,  1,  l));
    
    m.addQuad( // left z.
      V3(-1, l, -1),
      V3(-1, h, -1),
      V3(-1, h,  1),
      V3(-1, l,  1));
    m.addQuad( // right z.
      V3( 1, l, -1),
      V3( 1, l,  1),
      V3( 1, h,  1),
      V3( 1, h, -1));
    m.addQuad( // bottom z.
      V3( l, -1, -1),
      V3( l, -1,  1),
      V3( h, -1,  1),
      V3( h, -1, -1));
    m.addQuad( // top z.
      V3( l,  1,  -1),
      V3( h,  1,  -1),
      V3( h,  1,  1),
      V3( l,  1,  1));
  }
  return m
}
