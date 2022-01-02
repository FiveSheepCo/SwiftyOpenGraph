import Foundation

func _getDate(from string: String?) -> Date? {
    string.flatMap { (dateString: String) in
        let optionSets: [ISO8601DateFormatter.Options] = [
            [.withFullDate, .withDashSeparatorInDate],
            [.withInternetDateTime],
            [.withFullDate, .withFullTime, .withSpaceBetweenDateAndTime],
            [.withYear, .withWeekOfYear, .withDashSeparatorInDate],
            [.withYear, .withWeekOfYear, .withDay, .withDashSeparatorInDate],
            [.withYear, .withDay, .withDashSeparatorInDate]
        ]
        
        for options in optionSets {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = options
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
    
        return nil
    }
}
