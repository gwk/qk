// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


func atmInc(ptr: UnsafeMutablePointer<I64>) { OSAtomicIncrement64(ptr) }


struct AtmCounters {
  var _counters: [I64]
  
  init(count: Int) {
    _counters = [I64](count: count, repeatedValue: 0)
  }
  
  var count: Int { return _counters.count }
  
  subscript (idx: Int) -> I64 { return _counters[idx] }
  
  mutating func withPtr(idx: Int, @noescape body: (UnsafeMutablePointer<I64>) -> ()) {
    assert(idx < count)
    self._counters.withUnsafeMutableBufferPointer() {
      (inout buffer: UnsafeMutableBufferPointer<I64>) -> () in
      body(buffer.baseAddress + idx)
    }
  }
  
  mutating func inc(idx: Int) {
    withPtr(idx) {
      atmInc($0)
    }
  }
  
  mutating func zeroAll() {
    for i in 0..<count {
      _counters[i] = 0
    }
  }
}

