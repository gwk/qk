#!/usr/bin/env python3

PixFmtBitU8  = 1 << 0
PixFmtBitU16 = 1 << 1
PixFmtBitF32 = 1 << 2
PixFmtBitA   = 1 << 3
PixFmtBitX   = 1 << 4
PixFmtBitL   = 1 << 5
PixFmtBitRGB = 1 << 6
PixFmtBitD16 = 1 << 7
PixFmtBitD24 = 1 << 8
PixFmtBitD32 = 1 << 9
PixFmtBitM2 = 1 << 10
PixFmtBitM4 = 1 << 11
PixFmtBitM8 = 1 << 12

channels = [
  ['A',],
  ['L',],
  ['L', 'A'],
  ['RGB',],
  ['RGB', 'A'],
  ['RGB', 'X'],
]

widths = ['U8', 'U16', 'F32']
depths = [None, 'D16', 'D24', 'D32']
samples = [None, 'M2', 'M4', 'M8']

print('  case None = 0')

def gen(f):
  for c in channels:
    for w in widths:
      for d in depths:
        for s in samples:
          els = c + list(filter(lambda x: x, [w, d, s]))
          name = ''.join(els)
          bits = ['PixFmtBit' + x for x in els]
          expr = '|'.join(bits)
          f(name, expr)

def case(name, expr):
  print('  case {} = {} // {}'.format(name, hex(eval(expr)), expr))

def description(name, expr):
  print('    case .{}: return "{}"'.format(name, name))

gen(case)
gen(description)
