// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
//
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// For more information, please refer to <https://unlicense.org>

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
