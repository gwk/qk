#!/usr/bin/env python3
# © 2015 George King. Permission to use this file is granted in license-qk.txt.

from gen_util import *


def gen_vec(orig_type, dim, s_type, fs_type, v_type, v_prev, is_simd, is_novel):
  # dim: integer dimension.
  # s_type: T type var or concrete numeric type.
  # fs_type: the appropriate float scalar type, where returning an int makes no sense.
  # v_type: the full type name being generated.
  # v_prev: lower dimension vector type, e.g. v_type=V3S, v_prev=V2S. None for dim == 2.
  comps = all_v_comps[:dim]
  comps_a = ['a.' + c for c in comps]
  comps_b = ['b.' + c for c in comps]
  comps_ab = [p for p in zip(comps_a, comps_b)]
  comps_colors = list(zip('la' if dim == 2 else 'rgba', comps))
  public = 'public ' if not is_simd else ''
  is_float = s_type.startswith('F')
  needs_eq = is_simd or is_novel

  protocols = [fmt('VecType$', dim)]
  if is_float:
    protocols.append('FloatVecType')
  else:
    protocols.append('IntVecType')
  if needs_eq:
    protocols.append('Equatable')

  protocols.append('CustomStringConvertible')
  protocols.append('JsonArrayInitable')

  if is_simd:
    outL('public typealias $ = $\n', v_type, orig_type)

  decl_keyword = 'public struct' if is_novel else 'extension'
  outL('$ $ : $ {', decl_keyword, v_type, jc(protocols))
  outL('  typealias Scalar = $', s_type)
  outL('  typealias FloatType = $', fs_type)
  outL('  typealias VSType = V$S', dim)
  outL('  typealias VDType = V$D', dim)
  outL('  typealias VU8Type = V$U8', dim)

  if is_novel:
    for c in comps:
      outL('  var $: Scalar', c)
    outL('  init($) {', jcf('_ $: Scalar', comps))
    for c in comps:
      outL('    self.$ = $', c, c)
    outL('  }')
    outL('  init() { self.init($) }',  jc('0' for c in comps))

  for d in range(dim, 5):
    for st, suffix, fst, f_suffix, simd_type_prefix, is_novel in types:
      if d == dim and st == s_type:
        continue
      vt = fmt('V$$', d, suffix)
      outL('  init(_ v: $) {', vt)
      outL('    self.init($)', jcf('Scalar(v.$)', comps))
      outL('  }')
  
  if v_prev:
    last_comp = comps[dim - 1]
    outL('  init(_ v: $, $: Scalar) {', v_prev, last_comp)
    outL('    self.init($)', jc(fmt('v.$', c) if i < dim - 1 else last_comp for i, c in enumerate(comps)))
    outL('  }')
  
  outL('  init(jsonArray: JsonArray) throws {')
  outL('    if jsonArray.count > $ {', dim)
  outL('      throw Json.Error.ExcessEl(index: $, exp: $.self, json: jsonArray.raw)', dim, v_type)
  outL('    }')
  outL('    self.init($)', jc(fmt('try jsonArray.el($).conv() as $', i, s_type) for i in range(dim)))
  outL('  }')
  outL('')

  outL('  static let zero = $($)', v_type, jc('0' for comp in comps))

  for c in comps:
    outL('  static let unit$ = $($)',
      c.upper(), v_type, jc('1' if d == c else '0' for d in comps))

  outL('  public var description: String { return "$($)" }',
    v_type, jc([r'\({})'.format(c) for c in comps]))

  outL('  var vs: V$S { return V$S($) }', dim, dim, jcf('F32($)', comps))
  outL('  var vd: V$D { return V$D($) }', dim, dim, jcf('F64($)', comps))

  outL('  var sqrLen: FloatType { return ($) }', jf(' + ', 'FloatType($).sqr', comps))
  outL('  var aspect: FloatType { return FloatType(x) / FloatType(y) }')

  for c_col, c in comps_colors:
    outL('  var $: Scalar {', c_col)
    outL('    get { return $ }', c)
    outL('    set { $ = newValue }', c)
    outL('  }')
  
  # TODO: swizzles.

  if s_type == 'U8':
    outL('  var toSPixel: VSType { return VSType($) }', jcf('F32($) / F32(0xFF)', comps))

  if is_float:
    outL('')
    outL('  var allNormal: Bool { return $ }', jf(' && ', '$.isNormal', comps))
    outL('  var allFinite: Bool { return $ }', jf(' && ', '$.isFinite', comps))
    outL('  var allZero: Bool { return $ }', jf(' && ', '$.isNormal', comps))
    outL('  var anySubnormal: Bool { return $}', jf(' || ', '$.isSubnormal', comps))
    outL('  var anyInfite: Bool { return $}', jf(' || ', '$.isInfinite', comps))
    outL('  var anyNaN: Bool { return $}', jf(' || ', '$.isNaN', comps))
    outL('  var norm: $ { return self / self.len }', v_type)
    outL('  var clampToUnit: $ { return $($) }', v_type, v_type, jcf('clamp($, min: 0, max: 1)', comps))
    outL('  var toU8Pixel: VU8Type { return VU8Type($) }', jcf('U8(clamp($ * 255, min: 0, max: 255))', comps))
    outL('  var heading: Scalar { return atan2(y, x) }')
    outL('')
    outL('  func dot(b: $) -> Scalar { return $ }',
      v_type, ' + '.join(fmt('($ * b.$)', c, c) for c in comps))
    outL('  func angle(b: $) -> Scalar { return acos(self.dot(b) / (self.len * b.len)) }',
      v_type)
    outL('  func lerp(b: $, _ t: Scalar) -> $ { return self * (1 - t) + b * t }',
      v_type, v_type)

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

  if needs_eq:
    outL('public func ==(a: $, b: $) -> Bool {', v_type, v_type)
    outL('  return $', ' && '.join(fmt('a.$ == b.$', c, c) for c in comps))
    outL('}\n')

if __name__ == '__main__':
  args = sys.argv[1:]
  expected = ['orig_type', 'dimension', 'scalar_type', 'float_scalar_type', 'import_name']
  if args and len(args) != len(expected):
    errL('error: found $ args; expected $: $', len(args), len(expected), jc(expected))
    sys.exit(1)

  outL('''\
// © 2015 George King. Permission to use this file is granted in license-qk.txt.
// This file is generated by gen-vec.py.
  ''')

  outL('import Darwin')

  if args:
    (orig_type, dim_string, s_type, fs_type, import_name) = args
    last = orig_type[-1]
    if last in ('3', '4'):
      v_prev = orig_type[:-1] + str(int(last) - 1)
    else:
      v_prev = None
    dim = int(dim_string)
    v_type = orig_type
    outL('import $\n\n', import_name)
    gen_vec(orig_type, dim, s_type, fs_type, v_type, v_prev=v_prev, is_simd=False, is_novel=False)

  else:
    outL('import simd\n')
    for d in dims:
      for s_type, suffix, fs_type, f_suffix, simd_type_prefix, is_novel in types:
        outL('')
        simd_type = fmt('$$', simd_type_prefix, d)
        v_type = fmt('V$$', d, suffix)
        v_prev = fmt('V$$', d - 1, suffix) if d > 2 else None
        gen_vec(simd_type, d, s_type, fs_type, v_type, v_prev, is_simd=bool(simd_type_prefix), is_novel=is_novel)

