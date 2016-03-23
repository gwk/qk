// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension OutputStreamType {

  mutating func write(items: [Any], sep: String, end: String) {
    var first = true
    for item in items {
      if first {
        first = false
      } else {
        self.write(sep)
      }
      self.write(String(item))
    }
    self.write(end)
  }
}
