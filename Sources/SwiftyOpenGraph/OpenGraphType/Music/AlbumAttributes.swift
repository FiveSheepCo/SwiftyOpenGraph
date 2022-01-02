import Foundation

extension OpenGraphType {
    
    public struct AlbumAttributes {
        /// The song on this album.
        public let songs: [SongAttributes]
        /// The musician that made this album.
        public let musician: String?
        /// The date the album was released.
        public let releaseDate: Date?
        
        enum Constants {
            static let type = "music.album"
            
            static let urlProperty = "music:album"
            static let musicianProperty = "music:musician"
            static let releaseDateProperty = "music:release_date"
        }
        
        init(properties: [_KeyValuePair]) {
            var songs: [SongAttributes] = []
            var musician: String?
            var releaseDateString: String?
            
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
                case Constants.musicianProperty:
                    musician = property.value
                case Constants.releaseDateProperty:
                    releaseDateString = property.value
                default:
                    break
                }
            }
            
            self.songs = songs
            self.musician = musician
            self.releaseDate = _getDate(from: releaseDateString)
        }
    }
}
