// © 2014 George King. Permission to use this file is granted in license-qk.txt.


extension Array {
  
  var lastIndex: Int? { return count > 0 ? count - 1 : nil }
  
  init(capacity: Int) {
    self = []
    self.reserveCapacity(capacity)
  }

}
