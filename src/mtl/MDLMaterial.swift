// © 2016 George King. Permission to use this file is granted in license-qk.txt.

import ModelIO


extension MDLMaterial: SequenceType {

  public struct Generator: GeneratorType {
    public typealias Element = MDLMaterialProperty

    let material: MDLMaterial
    var index: Int = 0

    init(material: MDLMaterial) {
      self.material = material
    }

    mutating public func next() -> Element? {
      if index >= material.count {
        return nil
      }
      let i = index
      index += 1
      return material[i]
    }
  }

  public func generate() -> Generator {
    return Generator(material: self)
  }
}
