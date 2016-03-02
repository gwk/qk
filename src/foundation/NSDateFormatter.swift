// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSDateFormatter {

  convenience init(_ format: String) {
    self.init()
    dateFormat = format
  }

  convenience init(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle = .NoStyle) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
  }

  convenience init(timeStyle: NSDateFormatterStyle) {
    self.init()
    self.dateStyle = .NoStyle
    self.timeStyle = timeStyle
  }
}
