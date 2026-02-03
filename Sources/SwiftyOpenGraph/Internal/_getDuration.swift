import Foundation

func _getDuration(from string: String?) -> Int? {
    guard let durationString = string, !durationString.isEmpty else {
        return nil
    }

    // If it's just an integer string, return it directly
    if let duration = Int(durationString) {
        return duration
    }

    // Match patterns like "PT3M25S"
    let regex = #/PT(\d+)M(\d+)S/#

    if let match = durationString.wholeMatch(of: regex),
       let minutes = Int(match.1),
       let seconds = Int(match.2) {
        return minutes * 60 + seconds
    }

    return nil
}
