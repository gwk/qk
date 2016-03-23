// © 2015 George King. Permission to use this file is granted in license-qk.txt.


extension Set {

  init<S: SequenceType where S.Generator.Element: SequenceType, S.Generator.Element.Generator.Element == Element>(seqs: S) {
    var set = Set()
    for s in seqs {
      set.unionInPlace(s)
    }
    self = set
  }

  @warn_unused_result
  static func fromUniqueSeq<S: SequenceType where S.Generator.Element == Element>(seq: S) throws -> Set {
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
  func setByRemoving(member: Element) -> Set<Element> {
    var set = self
    set.remove(member)
    return set
  }

  func setByReplacing(old: Element, with replacement: Element) -> Set<Element> {
    var set = self
    let removed = set.remove(old)
    assert(removed != nil)
    set.insert(replacement)
    return set
  }
}
