// © 2014 George King. Permission to use this file is granted in license-qk.txt.


class Index<T: Hashable> {
  var vals: [T] = []
  var indexes: [T:Int] = [:]
  
  init(_ vals: [T]) {
    self.vals = vals
    self.indexes = vals.enumerate().mapToDict { ($1, $0) }
  }
  

  var count: Int {
    assert(vals.count == indexes.count)
    return vals.count
  }
  
  func val(i: Int) -> T { return vals[i] }
  
  func index(val: T) -> Int? { return indexes[val] }
  
  func reg(val: T) -> Int {
    let oi = indexes[val]
    if let i = oi {
      return i
    } else {
        let i = count
      vals.append(val)
      indexes[val] = i
      return i
    }
  }
}

