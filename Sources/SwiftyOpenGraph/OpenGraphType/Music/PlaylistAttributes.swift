import Foundation

extension OpenGraphType {
    
    public struct PlaylistAttributes {
        /// The songs on this playlist.
        public let songs: [SongAttributes]
        /// The creator of this playlist.
        public let creator: String?
        
        enum Constants {
            static let type = "music.playlist"
            
            static let creatorProperty = "music:creator"
        }
        
        init(properties: [_KeyValuePair]) {
            var songs: [SongAttributes] = []
            var creator: String?
            
            for (index, property) in properties.enumerated() {
                switch property.key {
                case SongAttributes.Constants.urlProperty:
                    songs.append(
                        .init(
                            url: property.value,
                            properties: Array(properties[index+1..<properties.count]),
                            isInAlbumOrPlaylist: true
                        )
                    )
                case Constants.creatorProperty:
                    creator = property.value
                default:
                    break
                }
            }
            
            self.songs = songs
            self.creator = creator
        }
    }
}
