// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSBundle {

  public class var main: NSBundle { return NSBundle.mainBundle() }
  
  class func resPath(name: String) -> String {
    return main.pathForResource(name, ofType: nil)!
  }

  class func textNamed(name: String) throws -> String {
    let p = resPath(name)
    do {
      return try String(contentsOfFile: p, encoding: NSUTF8StringEncoding)
    } catch let e as NSError {
      print("could not read resource text: \(name) error: \(e)")
      throw e
    }
  }
}
