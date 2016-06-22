// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Darwin


func atmInc(_ ptr: UnsafeMutablePointer<I64>) { OSAtomicIncrement64(ptr) }
func atmDec(_ ptr: UnsafeMutablePointer<I64>) { OSAtomicDecrement64(ptr) }


class AtmCounters {
  private var _counters: Array<I64>
  
  init(count: Int) {
    _counters = Array<I64>(repeating: 0, count: count)
  }
  
  var count: Int { return _counters.count }
  
  subscript (idx: Int) -> I64 { return _counters[idx] }
  
  func withPtr(_ idx: Int, body: @noescape (UnsafeMutablePointer<I64>) -> ()) {
    assert(idx < count)
    self._counters.withUnsafeMutableBufferPointer() {
      (buffer: inout UnsafeMutableBufferPointer<I64>) -> () in
      body(buffer.baseAddress! + idx)
    }
  }
  
  func inc(_ idx: Int) {
    withPtr(idx) {
      atmInc($0)
    }
  }
  
  func dec(_ idx: Int) {
    withPtr(idx) {
      atmDec($0)
    }
  }
  
  func zeroAll() {
    for i in 0..<count {
      _counters[i] = 0
    }
  }
}

