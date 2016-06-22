// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreData


extension NSAttributeType: CustomStringConvertible {

  public var description: String {
    switch self {
    case .undefinedAttributeType: return "Undefined"
    case .integer16AttributeType: return "Integer16"
    case .integer32AttributeType: return "Integer32"
    case .integer64AttributeType: return "Integer64"
    case .decimalAttributeType: return "Decimal"
    case .doubleAttributeType: return "Double"
    case .floatAttributeType: return "Float"
    case .stringAttributeType: return "String"
    case .booleanAttributeType: return "Boolean"
    case .dateAttributeType: return "Date"
    case .binaryDataAttributeType: return "BinaryData"
    case .transformableAttributeType: return "Transformable"
    case .objectIDAttributeType: return "ObjectID"
    }
  }
}

extension NSAttributeDescription {

  var typeName: String {
    if let objcName = attributeValueClassName {
      if objcName == "NSString" {
        return "String"
      }
      return objcName
    } else {
      return "AnyObject"
    }
  }

  var valTypeName: String? {
    switch attributeType {
    case .integer16AttributeType: return "Int"
    case .integer32AttributeType: return "Int"
    case .integer64AttributeType: return "Int"
    case .doubleAttributeType: return "Double"
    case .floatAttributeType: return "Float"
    case .booleanAttributeType: return "Boolean"
    default: return nil
    }
  }

  var valAccessorName: String? {
    switch attributeType {
    case .integer16AttributeType: return "integer"
    case .integer32AttributeType: return "integer"
    case .integer64AttributeType: return "integer"
    case .doubleAttributeType: return "double"
    case .floatAttributeType: return "float"
    case .booleanAttributeType: return "bool"
    default: return nil
    }
  }
}


extension NSRelationshipDescription {

  var typeName: String {
    if isToMany {
      return isOrdered ? "NSOrderedSet" : "NSSet"
    } else {
      return (destinationEntity?.managedObjectClassName).or("MISSING_DESTINATION")
    }
  }
}


extension NSEntityDescription {

  var namesToProps: [String: NSPropertyDescription] {
    return propertiesByName as [String: NSPropertyDescription]
  }

  var namesToAttrs: [String: NSAttributeDescription] {
    return attributesByName as [String: NSAttributeDescription]
  }

  var namesToRels: [String: NSRelationshipDescription] {
    return relationshipsByName as [String: NSRelationshipDescription]
  }

  var props: [NSPropertyDescription] {
    return namesToProps.valsSortedByKey
  }

  var attrs: [NSAttributeDescription] {
    return namesToAttrs.valsSortedByKey
  }

  var rels: [NSRelationshipDescription] {
    return namesToRels.valsSortedByKey
  }

  var propNames: Set<String> {
    return Set(namesToProps.keys)
  }

  var attrNames: Set<String> {
    return Set(namesToAttrs.keys)
  }

  var relNames: Set<String> {
    return Set(namesToRels.keys)
  }

}


extension NSManagedObjectModel {

  convenience init?(path: String) {
    self.init(contentsOf: URL(string: path)!)
  }
}

