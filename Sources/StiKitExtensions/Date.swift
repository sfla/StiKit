import Foundation

extension Date{
    
    func timeString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }
    
    static func today() -> Date{
        let now = Date()
        let calendar = Calendar.current
        let dateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: now)
        return calendar.date(from: dateComponents)!
    }
    func isSameDayAsDate(_ otherDate: Date, plusOrMinusNumberOfDays numberOfDays: Int) -> Bool {
        let calendar = Calendar.current
        
        let flags: NSCalendar.Unit = [.era, .year, .month, .day]
        
        let otherDateComponents = (calendar as NSCalendar).components(flags, from: otherDate)
        let selfComponents = (calendar as NSCalendar).components(flags, from: self)
        
        return otherDateComponents.era! == selfComponents.era! &&
            otherDateComponents.year! == selfComponents.year! &&
            otherDateComponents.month! == selfComponents.month! &&
            otherDateComponents.day! + numberOfDays == selfComponents.day!
    }
    func isToday() -> Bool{
        return self.isSameDayAsDate(Date.today(), plusOrMinusNumberOfDays: 0)
    }
    func isTomorrow() -> Bool {
        return self.isSameDayAsDate(Date.today(), plusOrMinusNumberOfDays: 1)
    }
    func isYesterday() -> Bool {
        return self.isSameDayAsDate(Date.today(), plusOrMinusNumberOfDays: -1)
    }
    func dayString() -> String {
        if self.isToday(){
            return "time.today"
        }else if self.isTomorrow(){
            return "time.tomorrow"
        }else if self.isYesterday(){
            return "time.yesterday"
        }else{
            let dayDateFormatter = DateFormatter()
            if Date().numberOfDaysUntilDateTime(self) >= 0 && Date().numberOfDaysUntilDateTime(self) < 6 {
                dayDateFormatter.dateFormat = "EEEE"
                return dayDateFormatter.string(from: self)
            }
            else {
                dayDateFormatter.dateFormat = "EEE d. MMM"
                return dayDateFormatter.string(from: self)
            }
        }
    }
    
    func dateAndTimeString() -> String {
        
        let dayDateFormatter = DateFormatter()
        
        let dayText: String
        if isYesterday() || isToday() || isTomorrow() {
            dayDateFormatter.timeStyle = DateFormatter.Style.none;
            dayDateFormatter.dateStyle = DateFormatter.Style.short
            dayDateFormatter.doesRelativeDateFormatting = true
            
            dayText = dayDateFormatter.string(from: self)
        }
        else if Date().numberOfDaysUntilDateTime(self) >= 0 && Date().numberOfDaysUntilDateTime(self) <= 7 {
            dayDateFormatter.dateFormat = "EEEE"
            dayText = dayDateFormatter.string(from: self)
        }
        else {
            dayDateFormatter.dateFormat = "EEE d. MMM"
            dayText = dayDateFormatter.string(from: self)
        }
        
        return dayText + " " + self.timeString()
    }
    func dayAndTimeString(accessibility:Bool = false) -> String {
        return "\(dayString()) \(accessibility ? "time.at" : "time.at.short") \(timeString())"
    }
    func monthAndYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
    func numberOfDaysUntilDateTime(_ toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let difference = calendar.dateComponents([.day], from: self, to: toDateTime)
        return difference.day!
    }
}
