#!/usr/bin/env python3
# © 2015 George King.
# Permission to use this file is granted in license-qk.txt.

from gen_util import *


def gen_vec(dim, s_type, fs_type, v_type, fv_type, v_prev, import_name, is_existing):
  # dim: integer dimension.
  # s_type: T type var or concrete numeric type.
  # fs_type: the appropriate float scalar type, where returning an int makes no sense.
  # v_type: the full type name being generated.
  # fv_type: the appropriate float vector type.
  comps = all_v_comps[:dim]
  comps_a = ['a.' + c for c in comps]
  comps_b = ['b.' + c for c in comps]
  comps_ab = [p for p in zip(comps_a, comps_b)]
  comps_colors = list(zip('la' if dim == 2 else 'rgba', comps))
  public = 'public ' if is_existing else ''
  is_float = s_type.startswith('F')

  if import_name:
    outL('import $\n', import_name)

  protocols = fmt('Printable, VecType$', dim)
  if is_float:
    protocols += ', FloatVecType'
  else:
    protocols += ', IntVecType'

  if is_existing:
    #outL('extension $: $ {', v_type, protocols) # broken
    outL('extension $ {', v_type)
  else:
    outL('struct $: Equatable, $ {', v_type, protocols)
    outL('  var $: $', jc(comps), s_type)

  outL('  typealias ScalarType = $', s_type)
  outL('  typealias FloatType = $', fs_type)
  outL('  typealias VSType = V$S', dim)
  outL('  typealias VDType = V$D', dim)

  outL('  init($) {', jc(fmt('_ $: $ = 0', comp, s_type) for comp in comps))
  for c in comps:
    outL('    self.$ = $', c, c)
  outL('  }')
  
  outL('  init(_ v: $) { self = v }', v_type)

  for d in range(dim, 5):
    for st, suffix, fst, f_suffix in types:
      if d == dim and st == s_type:
        continue
      vt = fmt('V$$', d, suffix)
      outL('  init(_ v: $) {', vt)
      for c in comps:
        outL('    self.$ = $(v.$)', c, s_type, c)
      outL('  }')
  
  if dim > 2:
    outL('  init(_ v: $, _ s: $) {', v_prev, s_type)
    for i, c in enumerate(comps):
      outL('    self.$ = $', c, fmt('v.$', c) if i < dim - 1 else 's')
    outL('  }')
  
  outL('  static let zero = $($)', v_type, jc('0' for comp in comps))

  for c in comps:
    outL('  static let unit$ = $($)',
      c.upper(), v_type, jc('1' if d == c else '0' for d in comps))

  outL('  $var description: String { return "$($)" }',
    public, v_type, jc([r'\({})'.format(c) for c in comps]))
  outL('  var vs: V$S { return V$S($) }', dim, dim, jcf('F32($)', comps))
  outL('  var vd: V$D { return V$D($) }', dim, dim, jcf('F64($)', comps))
  outL('  var sqrLen: $ { return ($) }',
    fs_type, ' + '.join(fmt('$($).sqr', fs_type, c) for c in comps))
  outL('  var len: $ { return sqrLen.sqrt }', fs_type)
  outL('  var aspect: $ { return $(x) / $(y) }', fs_type, fs_type, fs_type)

  for c, c_orig in comps_colors:
    outL('  var $: $ { return $ }', c, s_type, c_orig)

  # TODO: swizzles.

  if is_float:
    outL('')
    outL('  var allNormal: Bool { return $ }', jf(' && ', '$.isNormal', comps))
    outL('  var allFinite: Bool { return $ }', jf(' && ', '$.isFinite', comps))
    outL('  var allZero: Bool { return $ }', jf(' && ', '$.isNormal', comps))
    outL('  var anySubnormal: Bool { return $}', jf(' || ', '$.isSubnormal', comps))
    outL('  var anyInfite: Bool { return $}', jf(' || ', '$.isInfinite', comps))
    outL('  var anyNaN: Bool { return $}', jf(' || ', '$.isNaN', comps))
    outL('')
    outL('  var norm: $ { return $(self) / self.len }', fv_type, fv_type)
    outL('  var clampToUnit: $ { return $($) }', v_type, v_type, jcf('clamp($, 0, 1)', comps))
    outL('  func dist(b: $) -> $ { return (b - self).len }', v_type, s_type)
    outL('  func dot(b: $) -> $ { return $ }',
      v_type, s_type, ' + '.join(fmt('($ * b.$)', c, c) for c in comps))
    outL('  func angle(b: $) -> $ { return acos(self.dot(b) / (self.len * b.len)) }',
      v_type, s_type)
    outL('  func lerp(b: $, _ t: $) -> $ { return self * (1 - t) + b * t }',
      v_type, s_type, v_type)

    if dim >= 3:
      outL('')
      cross_pairs = ['yz', 'zx', 'xy', '__'][:dim]
      outL('  func cross(b: $) -> $ { return $(', v_type, v_type, v_type)
      for i, (a, b) in enumerate(cross_pairs):
        if a == '_':
          outL('  0')
        else:
          comma = '' if i == dim - 1 else ','
          outL('  $ * b.$ - $ * b.$$', a, b, b, a, comma)
      outL(')}')

    outL('')

  outL('}\n')

  for op in ops:
    cons_comps_v = jc(fmt('$ $ $', a, op, b) for a, b in comps_ab) # e.g. 'a.x + b.x'.
    outL('func $(a: $, b: $) -> $ { return $($) }', op, v_type, v_type, v_type, v_type, cons_comps_v)
  for op in ops:
    cons_comps_s = jc(fmt('$ $ s', a, op) for a in comps_a) # e.g. 'a.x + s'.
    outL('func $(a: $, s: $) -> $ { return $($) }', op, v_type, s_type, v_type, v_type, cons_comps_s)

  outL('')

  if not is_existing:
    outL('func ==(a: $, b: $) -> Bool {', v_type, v_type)
    outL('  return $', ' && '.join(fmt('a.$ == b.$', c, c) for c in comps))
    outL('}\n')

if __name__ == '__main__':
  args = sys.argv[1:]
  expected = ['dimension', 'import_name']
  if args and len(args) != len(expected):
    errFL('error: found $ args; expected $: $', len(args), len(expected), jc(expected))
    sys.exit(1)

  outL('''\
// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.
// This file is generated by gen-vec.py.

  ''')

  if args:
    (ds, import_name) = args
    dim = int(ds)
    v_type = fmt('V$', dim)
    v_prev = fmt('V$', dim - 1)
    gen_vec(dim, 'Flt', 'Flt', v_type, v_type, v_prev, import_name, is_existing=True)

  else:
    for d in dims:
      for st, suffix, fst, f_suffix in types:
        vt = fmt('V$$', d, suffix)
        fvt = fmt('V$$', d, f_suffix)
        v_prev = fmt('V$$', d - 1, suffix)
        gen_vec(d, st, fst, vt, fvt, v_prev, import_name='', is_existing=False)

