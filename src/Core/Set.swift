// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension Set {

  init<S: Sequence where S.Iterator.Element: Sequence, S.Iterator.Element.Iterator.Element == Element>(seqs: S) {
    var set = Set()
    for s in seqs {
      set.formUnion(s)
    }
    self = set
  }

  @warn_unused_result
  static func fromUniqueSeq<S: Sequence where S.Iterator.Element == Element>(_ seq: S) throws -> Set {
    var set: Set = []
    for el in seq {
      if set.contains(el) {
        throw DuplicateElError(el: el)
      }
      set.insert(el)
    }
    return set
  }

  @warn_unused_result
  func setByRemoving(_ member: Element) -> Set<Element> {
    var set = self
    set.remove(member)
    return set
  }

  func setByReplacing(_ old: Element, with replacement: Element) -> Set<Element> {
    var set = self
    let removed = set.remove(old)
    assert(removed != nil)
    set.insert(replacement)
    return set
  }
}
