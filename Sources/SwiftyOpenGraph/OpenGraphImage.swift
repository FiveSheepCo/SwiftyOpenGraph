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

public struct OpenGraphImage {
    
    public let url: String
    public let secureUrl: String?
    public let mimeType: String?
    public let width: Int?
    public let height: Int?
    public let alt: String?
    
    internal enum Constants {
        static let urlProperties = ["og:image", "og:image:url"]
        static let secureUrlProperty = "og:image:secure_url"
        static let mimeTypeProperty = "og:image:type"
        static let widthProperty = "og:image:width"
        static let heightProperty = "og:image:height"
        static let altProperty = "og:image:alt"
    }
    
    init(url: String, followingProperties: [_KeyValuePair]) {
        var secureUrl: String? = nil
        var mimeType: String? = nil
        var width: Int? = nil
        var height: Int? = nil
        var alt: String? = nil
        
        loop: for property in followingProperties {
            switch property.key {
            case Constants.secureUrlProperty:
                secureUrl = property.value
            case Constants.mimeTypeProperty:
                mimeType = property.value
            case Constants.widthProperty:
                width = Int(property.value)
            case Constants.heightProperty:
                height = Int(property.value)
            case Constants.altProperty:
                alt = property.value
            default:
                // Break the for loop the first time a non-image property is found
                if !property.key.starts(with: Constants.urlProperties[0]) || property.key == Constants.urlProperties[0] {
                    break loop
                }
            }
        }
        
        self.url = url
        self.secureUrl = secureUrl
        self.mimeType = mimeType
        self.width = width
        self.height = height
        self.alt = alt
    }
}
