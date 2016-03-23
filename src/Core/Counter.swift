// © 2016 George King. Permission to use this file is granted in license.txt.


struct Counter<Key: Hashable> {
  var dict: [Key: Int] = [:]

  subscript(key: Key) -> Int { return dict[key].or(0) }

  mutating func increment(key: Key) -> Int {
    let c = self[key]
    dict[key] = c + 1
    return c
  }
}