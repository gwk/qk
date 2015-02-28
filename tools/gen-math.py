#!/usr/bin/env python3
# © 2014 George King.
# Permission to use this file is granted in license-qk.txt.

import sys
from collections import namedtuple
from itertools import zip_longest

Pair = namedtuple('Pair', ['a', 'b'])

dims = [2, 3, 4]
all_v_comps = ['x', 'y', 'z', 'w']
types = [('F32', 'S'), ('F64', 'D')]
ops = ['+', '-', '*', '/']

def fmt(f, *items):
  res = []
  chunks = f.split('$')
  for chunk, item in zip_longest(chunks, items, fillvalue=''):
    res.append(chunk)
    res.append(str(item))
  return ''.join(res)

def outL(f, *items):
  print(fmt(f, *items))

def je(a): return ''.join(a) # join with empty string.
def jc(a): return ', '.join(a) # join with comma.
def js(a): return ' '.join(a) # join with space.

def jcf(f, a): return jc([fmt(f, i) for i in a]) # format each item of the sequence.
def jcft(f, a): return jc([fmt(f, *t) for t in a]) # format each tuple of the sequence.

def gen_vec(d, t, tl, vt, isExisting=False):
  comps = all_v_comps[:d]
  comps_a = ['a.' + c for c in comps]
  comps_b = ['b.' + c for c in comps]
  comps_ab = [Pair(a, b) for a, b in zip(comps_a, comps_b)]
  public = 'public ' if isExisting else ''

  if isExisting:
    outL('import CoreGraphics\n')
    outL('extension $: Printable {', vt)
  else:
    outL('struct $: Printable, Equatable {', vt)
    outL('  var $: $', jc(comps), t)

  outL('  init($) {', jc(fmt('_ $: $ = 0', comp, t) for comp in comps))
  for c in comps:
    outL('    self.$ = $', c, c)
  outL('  }')
  
  for di in range(d, 5):
    for ti, til in types:
      vi = fmt('V$$', di, til)
      outL('  init(_ v: $) {', vi)
      for c in comps:
        outL('    self.$ = $(v.$)', c, t, c)
      outL('  }')
  
  if d > 2:
    vt_prev = fmt('V$$', d - 1, tl)
    outL('  init(_ v: $, _ s: $) {', vt_prev, t)
    for i, c in enumerate(comps):
      outL('    self.$ = $', c, fmt('v.$', c) if i < d - 1 else 's')
    outL('  }')
  
  outL('  static let zero = $($)', vt, jc('0' for comp in comps))

  outL('  $var description: String { return "$($)" }',
    public, vt, jc([r'\({})'.format(c) for c in comps]))
  outL('  var vs: V$S { return V$S($) }', d, d, jcf('F32($)', comps))
  outL('  var vd: V$D { return V$D($) }', d, d, jcf('F64($)', comps))
  outL('  var len: $ { return ($).sqrt }', t, ' + '.join(fmt('$.sqr', c) for c in comps))
  outL('  var norm: $ { return self / self.len }', vt)
  outL('  var clampToUnit: $ { return $($) }', vt, vt, jcf('clamp($, 0, 1)', comps))
  outL('}\n')

  for op in ops:
    cons_comps_v = jc(fmt('$ $ $', a, op, b) for a, b in comps_ab)
    outL('func $(a: $, b: $) -> $ { return $($) }', op, vt, vt, vt, vt, cons_comps_v)
  for op in ops:
    cons_comps_s = jc(fmt('$ $ s', a, op) for a in comps_a)
    outL('func $(a: $, s: $) -> $ { return $($) }', op, vt, t, vt, vt, cons_comps_s)

  outL('')

  if not isExisting:
    outL('func ==(a: $, b: $) -> Bool {', vt, vt)
    outL('  return $', ' && '.join(fmt('a.$ == b.$', c, c) for c in comps))
    outL('}\n')

def gen_mat(d, t, tl):
  v_comps = all_v_comps[:d]
  v_comps_a = ['a.' + c for c in v_comps]
  v_comps_b = ['b.' + c for c in v_comps]
  v_comps_ab = [Pair(a, b) for a, b in zip(v_comps_a, v_comps_b)]
  vt = fmt('V$$', d, tl)

  comps = [fmt('m$$', i, j) for i in range(d) for j in range(d)]
  comps_cols = [[fmt('m$$', j, i) for i in range(d)] for j in range(d)]
  comps_rows = [[fmt('m$$', i, j) for i in range(d)] for j in range(d)]
  comps_a = ['a.' + c for c in comps]
  comps_b = ['b.' + c for c in comps]
  comps_ab = [Pair(a, b) for a, b in zip(comps_a, comps_b)]
  mt = fmt('M$$', d, t)
  
  outL('struct $: Printable {', mt)
  outL('  var $: $', jc(comps), t)
  
  outL('  init($) {', jc(fmt('_ $: $', comp, t) for comp in comps))
  for c in comps:
    outL('    self.$ = $', c, c)
  outL('  }')
  
  outL('  init($) {', jc(fmt('_ c$: $', i, vt) for i in range(d)))
  outL('    self.init($)', jc(fmt('c$.$', i, v_comp) for i in range(d) for v_comp in v_comps))
  outL('  }')
  #if d > 2:
  #  outL('  init(_ v: $, _ s: $) {', vt_prev, t)
  #  for i, c in enumerate(comps):
  #    outL('    self.$ = $', c, fmt('v.$', c) if i < d - 1 else 's')
  #  outL('  }')
  
  outL('  var description: String { return "$($)" }', mt, jc(['\\({})'.format(c) for c in comps]))

  for i in range(d):
    outL('  var c$: $ { return $($) }', i, vt, vt, jc(comps_cols[i]))
  for i in range(d):
    outL('  var r$: $ { return $($) }', i, vt, vt, jc(comps_rows[i]))

  outL('}\n')

  outL('let $Zero = $($)', mt, mt, jc('0' for c in comps))
  outL('let $Identity = $($)', mt, mt, jc(str(int(i == j)) for j in range(d) for i in range(d)))
  outL('')

  # component-wise operations.
  for op in ['+', '-']:
    cons_comps_m = jc(fmt('$ $ $', a, op, b) for a, b in comps_ab)
    outL('func $(a: $, b: $) -> $ { return $($) }', op, mt, mt, mt, mt, cons_comps_m)
  for op in ['*', '/']:
    cons_comps_s = jc(fmt('$ $ s', a, op) for a in comps_a)
    outL('func $(a: $, s: $) -> $ { return $($) }', op, mt, t, mt, mt, cons_comps_s)
  outL('\n')

  scale_pars = jc(fmt('$: $', v_comp, t) for v_comp in v_comps)
  scale_args = jc((c if c == d else '0') for c in v_comps for d in v_comps)
  outL('func $Scale($) -> $ { return $($) }', mt, scale_pars, mt, mt, scale_args)


if __name__ == '__main__':
  args = sys.argv[1:]
  if not (len(args) == 0 or len(args) == 3):
    print('error: expect no args or: dim type vtype', file=sys.stderr)
    sys.exit(1)

  outL('''\
// © 2014-2015 George King.
// Permission to use this file is granted in license-qk.txt.
// This file is generated by gen-math.py.

  ''')

  if args:
    ds, t, vt = args
    d = int(ds)
    gen_vec(d, t, '', vt, isExisting=True) # empty letter creates correct V2, V3, V4.

  else:
    for d in dims:
      for t, tl in types:
        vt = fmt('V$$', d, tl)
        gen_vec(d, t, tl, vt)
    for d in dims:
      for t, tl in types:
        gen_mat(d, t, tl)
