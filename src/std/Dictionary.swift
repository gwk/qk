// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

import Foundation


extension Dictionary {
  
  func contains(key: Key) -> Bool {
    switch self[key] {
    case .None: return false
    case .Some: return true
    }
  }
}
