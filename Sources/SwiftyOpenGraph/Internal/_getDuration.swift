import Foundation

func _getDuration(from string: String?) -> Int? {
    string.flatMap { (durationString: String) in
        if let duration = Int(durationString) {
            return duration
        } else if let match = durationString.regexMatches(with: "PT(\\d+)M(\\d+)S")?.first,
                  let minutes = match.captureGroups[0]?.toInt,
                  let seconds = match.captureGroups[1]?.toInt {
            return minutes * 60 + seconds
        } else {
            return nil
        }
    }
}
