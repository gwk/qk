// © 2016 George King. Permission to use this file is granted in license-qk.txt.


final class SetRef<Element: Hashable>: CollectionType {
  // pass-by-reference Set type.

  typealias Generator = Set<Element>.Generator
  typealias Index = Set<Element>.Index

  var set: Set<Element> = []

  init() {}

  convenience init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S) {
    self.init()
    set = Set(sequence)
  }

  convenience init(arrayLiteral elements: Element...) {
    self.init()
    set = Set(elements)
  }

  convenience init(minimumCapacity: Int) {
    self.init()
    set = Set(minimumCapacity: minimumCapacity)
  }

  var count: Int { return set.count }

  var startIndex: Index { return set.startIndex }

  var endIndex: Index { return set.endIndex }

  var first: Element? { return set.first }

  var isEmpty: Bool { return set.isEmpty }

  subscript (index: Index) -> Element {
    get { return set[index] }
  }

  func generate() -> Generator { return set.generate() }

  func contains(member: Element) -> Bool { return set.contains(member) }

  func exclusiveOr<S: SequenceType where S.Generator.Element == Element>(sequence: S) -> Set<Element> {
    return set.exclusiveOr(sequence)
  }

  func exclusiveOrInPlace<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
    set.exclusiveOrInPlace(sequence)
  }

  func indexOf(member: Element) -> Index? {
    return set.indexOf(member)
  }

  func insert(member: Element) { set.insert(member) }

  func intersect<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Set<Element> {
    return set.intersect(sequence)
  }

  func intersectInPlace<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
    set.intersectInPlace(sequence)
  }

  func isDisjointWith<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool {
    return set.isDisjointWith(sequence)
  }
}

