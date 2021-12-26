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
    
    public struct VideoAttributes {
        
        /// The kind of the video.
        public let kind: SubKind
        /// Actors in the movie.
        public let actors: [Actor]
        /// Directors of the movie.
        public let directors: [String]
        /// Writers of the movie.
        public let writers: [String]
        /// The movie's length in seconds.
        public let duration: Int?
        /// The date the movie was released.
        public let releaseDate: Date?
        /// Tag words associated with this movie.
        public let tags: [String]
        /// Which series a tv episode belongs to.
        public let series: String?
        
        internal enum Constants {
            static let directorProperty = "video:director"
            static let writerProperty = "video:writer"
            static let durationProperty = "video:duration"
            static let releaseDateProperty = "video:release_date"
            static let tagProperty = "video:tag"
            static let seriesProperty = "video:series"
        }
        
        init(subKind: SubKind, properties: [_KeyValuePair]) {
            self.kind = subKind
            
            var actors: [Actor] = []
            var directors: [String] = []
            var writers: [String] = []
            var durationString: String?
            var releaseDateString: String?
            var tags: [String] = []
            var series: String?
            
            for (index, property) in properties.enumerated() {
                switch property.key {
                case Actor.Constants.urlProperty:
                    actors.append(
                        .init(
                            url: property.value,
                            followingProperties: Array(properties[index+1..<properties.count])
                        )
                    )
                case Constants.durationProperty:
                    durationString = property.value
                case Constants.directorProperty:
                    directors.append(property.value)
                case Constants.writerProperty:
                    writers.append(property.value)
                case Constants.tagProperty:
                    tags.append(property.value)
                case Constants.releaseDateProperty:
                    releaseDateString = property.value
                case Constants.seriesProperty:
                    series = property.value
                default:
                    break
                }
            }
            
            self.actors = actors
            self.directors = directors
            self.writers = writers
            self.duration = _getDuration(from: durationString)
            self.releaseDate = _getDate(from: releaseDateString)
            self.tags = tags
            self.series = series
        }
    }
}
