// © 2016 George King. Permission to use this file is granted in license-qk.txt.


extension OptionSet {

  mutating func toggle(_ el: Element) {
    if contains(el) {
      remove(el)
    } else {
      insert(el)
    }
  }

}
