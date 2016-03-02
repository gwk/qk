// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


let secPerDay: NSTimeInterval = 24 * 60 * 60

public func <(l: NSDate, r: NSDate) -> Bool { return l.compare(r) == .OrderedAscending }

extension NSDate: Comparable {
  
  var refTime: NSTimeInterval { return timeIntervalSinceReferenceDate }
  var unixTime: NSTimeInterval { return timeIntervalSince1970 }
  
  convenience init(refTime: NSTimeInterval) { self.init(timeIntervalSinceReferenceDate: refTime) }
  convenience init(unixTime: NSTimeInterval) { self.init(timeIntervalSince1970: unixTime) }
    
  func isSameDayAs(date: NSDate) -> Bool {
    let units = NSCalendarUnit.preciseToDay
    let s = NSCalendar.currentCalendar().components(units, fromDate: self)
    let d = NSCalendar.currentCalendar().components(units, fromDate: date)
    return s.day == d.day && s.month == d.month && s.year == d.year && s.era == d.era
  }
  
  var isToday: Bool { return isSameDayAs(NSDate()) }
  
  func plusHours(hours: Double) -> NSDate {
    return NSDate(timeIntervalSinceReferenceDate: refTime + hours * 60 * 60)
  }
  
  var dayDate: NSDate {
    let cal = NSCalendar.currentCalendar()
    let c = cal.components(NSCalendarUnit.preciseToDay, fromDate: self)
    c.hour = 0
    c.minute = 0
    c.second = 0
    c.nanosecond = 0
    return cal.dateFromComponents(c)!
  }

  var nextDayDate: NSDate {
    return plusHours(24).dayDate
  }
  
  func sameTimePlusDays(days: Int) -> NSDate {
    let cal = NSCalendar.currentCalendar()
    let t = cal.components(NSCalendarUnit.timeOfDay, fromDate: self)
    let d = cal.components(NSCalendarUnit.preciseToDay, fromDate: plusHours(24))
    d.hour = t.hour
    d.minute = t.minute
    d.second = t.second
    d.nanosecond = t.nanosecond
    return cal.dateFromComponents(d)!
  }
  
  var weekdayFromSundayAs1: Int { // 1-indexed weekday beginning with sunday.
    let cal = NSCalendar.currentCalendar()
    let c = cal.components(NSCalendarUnit.Weekday, fromDate: self)
    return c.weekday
  }
  
  var weekday: Int { // 0-indexed weekday beginning with monday.
    return (weekdayFromSundayAs1 + 5) % 7
  }
  
  var dayAndWeekday: (Int, Int) {
    let cal = NSCalendar.currentCalendar()
    let c = cal.components(NSCalendarUnit.dayAndWeekday, fromDate: self)
    return (c.day, (c.weekday + 5) % 7)
  }
}
