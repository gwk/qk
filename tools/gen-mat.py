#!/usr/bin/env python3
# © 2015 George King.
# Permission to use this file is granted in license-qk.txt.

from gen_util import *


def gen_mat(dim, t, suffix):
  def isLast(i): return i == dim - 1
  def areLast(i, j): return isLast(i) and isLast(j)
  def commaUnlessIsLast(i): return '' if isLast(i) else ','
  def commaUnlessAreLast(i, j): return '' if areLast(i, j) else ','

  vt = fmt('V$$', dim, suffix)
  mt = fmt('M$$', dim, suffix)
  rng = range(dim)
  rng_sqr = tuple(product(rng, rng))

  v_comps = all_v_comps[:dim]
  v_comps_a = tuple('a.' + c for c in v_comps)
  v_comps_b = tuple('b.' + c for c in v_comps)
  v_comps_ab = tuple(zip(v_comps_a, v_comps_b))

  els = tuple(fmt('m$$', i, j) for i, j in rng_sqr)
  els_cols = tuple(tuple(fmt('m$$', i, j) for j in rng) for i in rng)
  els_rows = tuple(tuple(fmt('m$$', i, j) for i in rng) for j in rng)
  els_l = tuple('l.' + c for c in els)
  els_r = tuple('r.' + c for c in els)
  els_lr = tuple(zip(els_l, els_r))
  
  outL('struct $: Printable {', mt)
  outL('  var $: $', jc(els), t)
  
  outL('  init($) {', jc(fmt('_ $: $', el, t) for el in els))
  for c in els:
    outL('    self.$ = $', c, c)
  outL('  } // init with elements in column major order.\n')
  
  outL('  init($) {', jc(fmt('_ c$: $', i, vt) for i in rng))
  outL('    self.init($)', jc(fmt('c$.$', i, v_comps[j]) for i, j in rng_sqr))
  outL('  } // init with column vectors.\n')

  outL('  var description: String { return "$($)" }',
    mt, jc(['\\({})'.format(c) for c in els]))

  for i in rng:
    outL('  var c$: $ { return $($) }', i, vt, vt, jc(els_cols[i]))
  for j in rng:
    outL('  var r$: $ { return $($) }', j, vt, vt, jc(els_rows[j]))

  outL('  static let zero = $($)', mt, jc('0' for e in els))
  outL('  static let ident = $($)', mt, jc(('1' if (i == j) else '0') for i, j in rng_sqr))

  scale_pars = jc(fmt('$: $', c, t) for c in v_comps)
  scale_args = jc((c if c == r else '0') for c, r in product(v_comps, v_comps))
  outL('  static func scale($) -> $ { return $($) }\n', scale_pars, mt, mt, scale_args)

  if dim >= 3:
    for k, ck in enumerate(v_comps[:3]): # k is index of rotation axis.
      outL('  static func rot$(theta: $) -> $ { return $(', ck.upper(), t, mt, mt)
      for j, cj in enumerate(v_comps):
        def rot_comp(i, ci):
          if i == k or j == k or i == 3 or j == 3:
            return '1' if i == j else '0'
          if i == j:
            return 'cos(theta)'
          # pick the sign of the sin term by hand, based on row j.
          # would love to find a more conceptually meaningful way of choosing the sign.
          if k == 0:   isNegSinTerm = (j == 2)
          elif k == 1: isNegSinTerm = (j == 0)
          elif k == 2: isNegSinTerm = (j == 1)
          else: assert False
          return fmt('$sin(theta)', '-' if isNegSinTerm else '')
        outL('    $$',
          jc(rot_comp(i, ci).rjust(11) for i, ci in enumerate(v_comps)),
          ',' if j < dim - 1 else '')
      outL('  )}\n')

    outL('  static func rot(#theta: $, norm: $) -> $ {', t, vt, mt)
    outL('    if !theta.isNormal { return ident }')
    outL('    let _cos = cos(theta)')
    outL('    let _cosp = 1 - _cos')
    outL('    let _sin = sin(theta)')
    outL('    return $(', mt)

    rot_terms = [
      [ '_cos + _cosp * norm.x * norm.x',
        '_cosp * norm.x * norm.y + norm.z * _sin',
        '_cosp * norm.x * norm.z - norm.y * _sin',
        0],

      [ '_cosp * norm.x * norm.y - norm.z * _sin',
        '_cos + _cosp * norm.y * norm.y',
        '_cosp * norm.y * norm.z + norm.x * _sin',
        0],

      [ '_cosp * norm.x * norm.z + norm.y * _sin',
        '_cosp * norm.y * norm.z - norm.x * _sin',
        '_cos + _cosp * norm.z * norm.z',
        0],

      [0, 0, 0, 1]
    ]

    for i in rng:
      for j in rng:
        outL('      $$', rot_terms[i][j], commaUnlessAreLast(i, j))
    outL('  )}\n')

    outL('  static func rot(a: $, _ b: $) -> $ {', vt, vt, mt)
    outL('    return rot(theta: a.angle(b), norm: a.cross(b).norm)')
    outL('  }\n')

  outL('}\n')

  # element-wise operations.
  for op in ['+', '-']:
    outL('func $(l: $, r: $) -> $ { return $($) }', 
      op, mt, mt, mt, mt, jc(fmt('$ $ $', l, op, r) for l, r in els_lr))
  for op in ['*', '/']:
    outL('func $(m: $, s: $) -> $ { return $($) }',
      op, mt, t, mt, mt, jc(fmt('m.$ $ s', e, op) for e in els))

  outL('')
  
  # matrix multiplication.
  # the column major formula is: mij = dot(left.rj, right.ci).
  # we expand it out so that even without optimization we do not create temporary vectors.
  outL('func *(l: $, r: $) -> $ { return $(', mt, mt, mt, mt)
  for i, j in rng_sqr:
    dot = jft(' + ', '(l.m$$ * r.m$$)', [(k, j, i, k) for k in rng])
    outL('  $$', dot, commaUnlessAreLast(i, j))
  outL(')}\n')

  # vector multiplication.
  # the column major formula is: vj = dot(left.rj, right.ci).
  # we expand it out so that even without optimization we do not create temporary vectors.
  outL('func *(l: $, r: $) -> $ { return $(', mt, vt, vt, vt)
  for j in rng:
    dot = jft(' + ', '(l.m$$ * r.$)', [(i, j, v_comps[i]) for i in rng])
    outL('  $$', dot, commaUnlessIsLast(j))
  outL(')}\n')


if __name__ == '__main__':

  outL('''\
// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.
// This file is generated by gen-mat.py.

// OpenGL claims to be row vs column major agnostic,
// defining matrices as "having translation components in the last n components."
// see https://www.opengl.org/archives/resources/faq/technical/transformations.htm

// however OpenGL is generally considered to be "column major",
// meaning that elements of columns are contiguous in memory.
// this is due to the use of column-major notation in the spec.

// this implementation follows that of GLKit, which is column-major.
// matrix elements are named with a (col, row) notation,
// e.g m23 indicates col=2, row=3,
// which in a 4x4 matrix is the 14th element in memory:
// (len * row) + col = (4 * 3) + 2 = 14

''')

  for d in dims:
    for s_type, suffix, fs_type, f_suffix in types:
      if suffix == 'I': continue
      gen_mat(d, s_type, suffix)

