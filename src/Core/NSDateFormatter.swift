// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension DateFormatter {

  convenience init(_ format: String) {
    self.init()
    dateFormat = format
  }

  convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style = .noStyle) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
  }

  convenience init(timeStyle: DateFormatter.Style) {
    self.init()
    self.dateStyle = .noStyle
    self.timeStyle = timeStyle
  }
}
