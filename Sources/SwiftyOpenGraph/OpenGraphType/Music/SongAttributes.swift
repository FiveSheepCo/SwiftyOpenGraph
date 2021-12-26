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
