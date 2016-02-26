// © 2016 George King. Permission to use this file is granted in license-qk.txt.


extension OptionSetType {

  mutating func toggle(el: Element) {
    if contains(el) {
      remove(el)
    } else {
      insert(el)
    }
  }

}
