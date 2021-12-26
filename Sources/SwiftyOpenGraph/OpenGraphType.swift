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
