// © 2016 George King. Permission to use this file is granted in license-qk.txt.


struct SetDict<Key: Hashable, SetElement: Hashable>: CollectionType {

  typealias SetType = SetRef<SetElement>
  typealias DictType = [Key:SetType]
  typealias Index = DictType.Index
  typealias Element = DictType.Element
  typealias Generator = DictType.Generator

  private var dict: DictType = [:]

  init() {}

  init(minimumCapacity: Int) {
    dict = DictType(minimumCapacity: minimumCapacity)
  }

  var count: Int { return dict.count }

  var startIndex: Index { return dict.startIndex }
  var endIndex: Index { return dict.endIndex }

  var isEmpty: Bool { return dict.isEmpty }

  var keys: LazyMapCollection<DictType, Key> { return dict.keys }

  var values: LazyMapCollection<DictType, SetType> { return dict.values }

  func generate() -> Generator { return dict.generate() }

  @warn_unused_result
  func indexForKey(key: Key) -> Index? { return dict.indexForKey(key) }

  mutating func popFirst() -> Element? { return dict.popFirst() }

  mutating func removeAll(keepCapacity keepCapacity: Bool = false) { dict.removeAll(keepCapacity: keepCapacity) }

  mutating func removeAtIndex(index: Index) -> Element { return dict.removeAtIndex(index) }

  mutating func removeValueForKey(key: Key) -> SetType? { return dict.removeValueForKey(key) }

  subscript (index: Index) -> Element { return dict[index] }

  subscript (key: Key) -> SetType? {
    get { return dict[key] }
    set { dict[key] = newValue }
  }

  mutating func insert(key: Key, member: SetElement) {
    if let set = dict[key] {
      set.insert(member)
    } else {
      let set = SetType()
      set.insert(member)
      dict[key] = set
    }
  }
}