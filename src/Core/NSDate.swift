// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import Foundation


let secPerMin: Time = 60
let secPerHour: Time = secPerMin * 60
let secPerDay: Time = secPerHour * 24


extension Date {
  
  var refTime: TimeInterval { return timeIntervalSinceReferenceDate }
  var unixTime: TimeInterval { return timeIntervalSince1970 }
  
  init(refTime: TimeInterval) { self.init(timeIntervalSinceReferenceDate: refTime) }
  init(unixTime: TimeInterval) { self.init(timeIntervalSince1970: unixTime) }
    
  func isSameDayAs(_ date: Date) -> Bool {
    let units = Calendar.Unit.preciseToDay
    let s = Calendar.current().components(units, from: self)
    let d = Calendar.current().components(units, from: date)
    return s.day == d.day && s.month == d.month && s.year == d.year && s.era == d.era
  }
  
  var isToday: Bool { return isSameDayAs(Date()) }
  
  func plusHours(_ hours: Double) -> Date {
    return Date(timeIntervalSinceReferenceDate: refTime + hours * 60 * 60)
  }
  
  var dayDate: Date {
    let cal = Calendar.current()
    var c = cal.components(Calendar.Unit.preciseToDay, from: self)
    c.hour = 0
    c.minute = 0
    c.second = 0
    c.nanosecond = 0
    return cal.date(from: c)!
  }

  var nextDayDate: Date {
    return plusHours(24).dayDate
  }
  
  func sameTimePlusDays(_ days: Int) -> Date {
    let cal = Calendar.current()
    let t = cal.components(Calendar.Unit.timeOfDay, from: self)
    var d = cal.components(Calendar.Unit.preciseToDay, from: plusHours(24))
    d.hour = t.hour
    d.minute = t.minute
    d.second = t.second
    d.nanosecond = t.nanosecond
    return cal.date(from: d)!
  }
  
  var weekdayFromSundayAs1: Int { // 1-indexed weekday beginning with sunday.
    let cal = Calendar.current()
    let c = cal.components(Calendar.Unit.weekday, from: self)
    return c.weekday!
  }
  
  var weekday: Int { // 0-indexed weekday beginning with monday.
    return (weekdayFromSundayAs1 + 5) % 7
  }
  
  var dayAndWeekday: (Int, Int) {
    let cal = Calendar.current()
    let c = cal.components(Calendar.Unit.dayAndWeekday, from: self)
    return (c.day!, (c.weekday! + 5) % 7)
  }
}
