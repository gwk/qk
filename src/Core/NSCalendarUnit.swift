// © 2015 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


extension Calendar.Unit {

  static var preciseToDay: Calendar.Unit {
    return [.era, .year, .month, .day]
  }

  static var precise: Calendar.Unit {
    return [.era, .year, .month, .day, .hour, .minute, .second, .nanosecond]
  }

  static var timeOfDay: Calendar.Unit {
    return [.hour, .minute, .second, .nanosecond]
  }

  static var dayAndWeekday: Calendar.Unit {
    return [.day, .weekday]
  }
}

