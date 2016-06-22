// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension Bundle {

  public class var main: Bundle { return Bundle.main() }
  
  class func resPath(_ name: String) -> String {
    return main.pathForResource(name, ofType: nil)!
  }

  class func textNamed(_ name: String) throws -> String {
    let p = resPath(name)
    do {
      return try String(contentsOfFile: p, encoding: String.Encoding.utf8)
    } catch let e as NSError {
      print("could not read resource text: \(name) error: \(e)")
      throw e
    }
  }
}
