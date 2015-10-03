// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import CoreData


extension NSAttributeType: CustomStringConvertible {

  public var description: String {
    switch self {
    case .UndefinedAttributeType: return "Undefined"
    case .Integer16AttributeType: return "Integer16"
    case .Integer32AttributeType: return "Integer32"
    case .Integer64AttributeType: return "Integer64"
    case .DecimalAttributeType: return "Decimal"
    case .DoubleAttributeType: return "Double"
    case .FloatAttributeType: return "Float"
    case .StringAttributeType: return "String"
    case .BooleanAttributeType: return "Boolean"
    case .DateAttributeType: return "Date"
    case .BinaryDataAttributeType: return "BinaryData"
    case .TransformableAttributeType: return "Transformable"
    case .ObjectIDAttributeType: return "ObjectID"
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
    case .Integer16AttributeType: return "Int"
    case .Integer32AttributeType: return "Int"
    case .Integer64AttributeType: return "Int"
    case .DoubleAttributeType: return "Double"
    case .FloatAttributeType: return "Float"
    case .BooleanAttributeType: return "Boolean"
    default: return nil
    }
  }

  var valAccessorName: String? {
    switch attributeType {
    case .Integer16AttributeType: return "integer"
    case .Integer32AttributeType: return "integer"
    case .Integer64AttributeType: return "integer"
    case .DoubleAttributeType: return "double"
    case .FloatAttributeType: return "float"
    case .BooleanAttributeType: return "bool"
    default: return nil
    }
  }
}


extension NSRelationshipDescription {

  var typeName: String {
    if toMany {
      return ordered ? "NSOrderedSet" : "NSSet"
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
    self.init(contentsOfURL: NSURL(string: path)!)
  }
}

