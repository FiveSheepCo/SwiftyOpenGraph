import Foundation

public enum OpenGraphType {
    
    internal enum Constants {
        static let typeProperty = "og:type"
    }
    
    case song(SongAttributes)
    case album(AlbumAttributes)
    case playlist(PlaylistAttributes)
    case radioStation(RadioStationAttributes)
    case video(VideoAttributes)
    case article(ArticleAttributes)
    case book(BookAttributes)
    case profile(ProfileAttributes)
    case website
    
    init(kVPs: [_KeyValuePair]) {
        let type = kVPs.first(where: { $0.key == Constants.typeProperty })?.value
        
        switch type {
        case SongAttributes.Constants.type:
            self = .song(.init(properties: kVPs))
        case AlbumAttributes.Constants.type:
            self = .album(.init(properties: kVPs))
        case PlaylistAttributes.Constants.type:
            self = .playlist(.init(properties: kVPs))
        case RadioStationAttributes.Constants.type:
            self = .radioStation(.init(properties: kVPs))
        default:
            if let type = type, let videoSubKind = VideoAttributes.SubKind(rawValue: type) {
                self = .video(.init(subKind: videoSubKind, properties: kVPs))
            } else {
                self = .website
            }
        }
    }
}
