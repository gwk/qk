// © 2015 George King. Permission to use this file is granted in license-qk.txt.


enum Chain<T> {
  case End
  indirect case Link(T, Chain)
  
  init<C: CollectionType where C.Generator.Element == T, C.Index: BidirectionalIndexType>(_ collection: C) {
    var c: Chain<T> = .End
    for e in collection.reverse() {
      c = Chain.Link(e, c)
    }
    self = c
  }
}

