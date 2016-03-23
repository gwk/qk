// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension NSCalendarUnit {

  static var preciseToDay: NSCalendarUnit {
    return NSCalendarUnit(rawValue: 0
      | NSCalendarUnit.Era.rawValue
      | NSCalendarUnit.Year.rawValue
      | NSCalendarUnit.Month.rawValue
      | NSCalendarUnit.Day.rawValue)
  }

  static var precise: NSCalendarUnit {
    return NSCalendarUnit(rawValue: 0
      | NSCalendarUnit.Era.rawValue
      | NSCalendarUnit.Year.rawValue
      | NSCalendarUnit.Month.rawValue
      | NSCalendarUnit.Day.rawValue
      | NSCalendarUnit.Hour.rawValue
      | NSCalendarUnit.Minute.rawValue
      | NSCalendarUnit.Second.rawValue
      | NSCalendarUnit.Nanosecond.rawValue)
  }

  static var timeOfDay: NSCalendarUnit {
    return NSCalendarUnit(rawValue: 0
      | NSCalendarUnit.Hour.rawValue
      | NSCalendarUnit.Minute.rawValue
      | NSCalendarUnit.Second.rawValue
      | NSCalendarUnit.Nanosecond.rawValue)
  }

  static var dayAndWeekday: NSCalendarUnit {
    return NSCalendarUnit(rawValue: 0
      | NSCalendarUnit.Day.rawValue
      | NSCalendarUnit.Weekday.rawValue)
  }
}

