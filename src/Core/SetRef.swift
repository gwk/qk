// © 2016 George King. Permission to use this file is granted in license-qk.txt.


final class SetRef<Element: Hashable>: Collection, ArrayLiteralConvertible {
  // pass-by-reference Set type.

  typealias Generator = Set<Element>.Generator
  typealias Index = Set<Element>.Index

  var set: Set<Element> = []

  init() {}

  init<S: Sequence where S.Generator.Element == Element>(_ sequence: S) {
    self.set = Set(sequence)
  }

  init(arrayLiteral elements: Element...) {
    self.set = Set(elements)
  }

  init(minimumCapacity: Int) {
    self.set = Set(minimumCapacity: minimumCapacity)
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

  func exclusiveOr<S: Sequence where S.Generator.Element == Element>(sequence: S) -> Set<Element> {
    return set.exclusiveOr(sequence)
  }

  func exclusiveOrInPlace<S: Sequence where S.Generator.Element == Element>(sequence: S) {
    set.exclusiveOrInPlace(sequence)
  }

  func index(of: Element) -> Index? {
    return set.index(of: of)
  }

  func insert(member: Element) { set.insert(member) }

  func intersect<S : Sequence where S.Generator.Element == Element>(sequence: S) -> Set<Element> {
    return set.intersect(sequence)
  }

  func intersectInPlace<S: Sequence where S.Generator.Element == Element>(sequence: S) {
    set.intersectInPlace(sequence)
  }

  func isDisjointWith<S : Sequence where S.Generator.Element == Element>(sequence: S) -> Bool {
    return set.isDisjointWith(sequence)
  }

  func removeAll() { set.removeAll() }
}

