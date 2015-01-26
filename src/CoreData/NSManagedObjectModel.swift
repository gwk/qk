// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.

import CoreData


extension NSAttributeType: Printable {

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
    case .BooleanAttributeType: return "Bool"
    case .DateAttributeType: return "Date"
    case .BinaryDataAttributeType: return "BinaryData"
    case .TransformableAttributeType: return "Transformable"
    case .ObjectIDAttributeType: return "ObjectID"
    }
  }
}

extension NSAttributeDescription {

  var attrClassName: String { return attributeValueClassName! }
  
  public var attrTypeName: String? {
    switch attributeType {
    case .UndefinedAttributeType: return nil
    case .Integer16AttributeType: return "Int"
    case .Integer32AttributeType: return "Int"
    case .Integer64AttributeType: return "Int"
    case .DecimalAttributeType: return "NSDecimalNumber"
    case .DoubleAttributeType: return "Double"
    case .FloatAttributeType: return "Float"
    case .StringAttributeType: return "String"
    case .BooleanAttributeType: return "Bool"
    case .DateAttributeType: return "NSDate"
    case .BinaryDataAttributeType: return "NSData"
    case .TransformableAttributeType: return nil
    case .ObjectIDAttributeType: return nil
    }
  }
}


extension NSManagedObjectModel {

  convenience init?(path: String) {
  self.init(contentsOfURL: NSURL(string: path)!)
  }
}

