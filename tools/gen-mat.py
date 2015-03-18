def gen_mat(dim, t, tl):
  v_comps = all_v_comps[:dim]
  v_comps_a = ['a.' + c for c in v_comps]
  v_comps_b = ['b.' + c for c in v_comps]
  v_comps_ab = [Pair(a, b) for a, b in zip(v_comps_a, v_comps_b)]
  v_type = fmt('V$$', dim, tl)

  comps = [fmt('m$$', i, j) for i in range(dim) for j in range(dim)]
  comps_cols = [[fmt('m$$', j, i) for i in range(dim)] for j in range(dim)]
  comps_rows = [[fmt('m$$', i, j) for i in range(dim)] for j in range(dim)]
  comps_a = ['a.' + c for c in comps]
  comps_b = ['b.' + c for c in comps]
  comps_ab = [Pair(a, b) for a, b in zip(comps_a, comps_b)]
  mt = fmt('M$$', dim, t)
  
  outL('struct $: Printable {', mt)
  outL('  var $: $', jc(comps), t)
  
  outL('  init($) {', jc(fmt('_ $: $', comp, t) for comp in comps))
  for c in comps:
    outL('    self.$ = $', c, c)
  outL('  }')
  
  outL('  init($) {', jc(fmt('_ c$: $', i, v_type) for i in range(dim)))
  outL('    self.init($)', jc(fmt('c$.$', i, v_comp) for i in range(dim) for v_comp in v_comps))
  outL('  }')

  outL('  var description: String { return "$($)" }', mt, jc(['\\({})'.format(c) for c in comps]))

  for i in range(dim):
    outL('  var c$: $ { return $($) }', i, v_type, v_type, jc(comps_cols[i]))
  for i in range(dim):
    outL('  var r$: $ { return $($) }', i, v_type, v_type, jc(comps_rows[i]))

  outL('}\n')

  outL('let $Zero = $($)', mt, mt, jc('0' for c in comps))
  outL('let $Identity = $($)', mt, mt, jc(str(int(i == j)) for j in range(dim) for i in range(dim)))
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
  scale_args = jc((c if c == dim else '0') for c in v_comps for dim in v_comps)
  outL('func $Scale($) -> $ { return $($) }', mt, scale_pars, mt, mt, scale_args)
