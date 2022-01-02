import Foundation

extension OpenGraphType {
    
    public struct SongAttributes {
        /// The url of the song. Only set if the song is included as a subtype (in an album or a playlist).
        public let url: String?
        
        /// The song's length in seconds.
        public let duration: Int?
        /// The album this song is from.
        public let albumUrl: String?
        /// Which disc of the album this song is on.
        public let disc: Int?
        /// Which track this song is.
        public let track: Int?
        /// The musician that made this song.
        public let musician: String?
        
        internal enum Constants {
            static let type = "music.song"
            
            static let urlProperty = "music:song"
            static let durationProperty = "music:duration"
            static let albumDiscProperty = "music:album:disc"
            static let albumTrackProperty = "music:album:track"
            static let songDiscProperty = "music:song:disc"
            static let songTrackProperty = "music:song:track"
            static let songDurationProperty = "music:song:duration"
            static let musicianProperty = "music:musician"
        }
        
        init(url: String? = nil, properties: [_KeyValuePair], isInAlbumOrPlaylist: Bool = false) {
            var durationString: String?
            var albumUrl: String?
            var disc: Int?
            var track: Int?
            var musician: String?
            
            if isInAlbumOrPlaylist {
                loop: for property in properties {
                    switch property.key {
                    case Constants.songDurationProperty:
                        durationString = property.value
                    case Constants.songDiscProperty:
                        disc = Int(property.value)
                    case Constants.songTrackProperty:
                        track = Int(property.value)
                    default:
                        // Break the for loop the first time a non-image property is found
                        if !property.key.starts(with: Constants.urlProperty) || property.key == Constants.urlProperty {
                            break loop
                        }
                    }
                }
            } else {
                for property in properties {
                    switch property.key {
                    case Constants.durationProperty:
                        durationString = property.value
                    case AlbumAttributes.Constants.urlProperty:
                        albumUrl = property.value
                    case Constants.albumDiscProperty:
                        disc = Int(property.value)
                    case Constants.albumTrackProperty:
                        track = Int(property.value)
                    case Constants.musicianProperty:
                        musician = property.value
                    default:
                        break
                    }
                }
            }
            
            self.url = url
            self.duration = _getDuration(from: durationString)
            self.albumUrl = albumUrl
            self.disc = disc
            self.track = track
            self.musician = musician
        }
    }
}
