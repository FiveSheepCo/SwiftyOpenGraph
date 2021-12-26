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
import SwiftSoup
import SchafKit

public struct OpenGraph {
    /// The title of your object as it should appear within the graph, e.g., "The Rock".
    public let title: String
    /// The type of your object, e.g., "video.movie". Depending on the type you specify, other properties may also be required.
    public let type: OpenGraphType
    /// An image URL which should represent your object within the graph.
    public let image: OpenGraphImage
    /// The canonical URL of your object that will be used as its permanent ID in the graph, e.g., "https://www.imdb.com/title/tt0117500/".
    public let url: String
    
    /// Other images included.
    public let additionalImages: [OpenGraphImage]
    
    /// Audio files to accompany this object.
    public let audios: [OpenGraphAudio]
    /// Video files that complement this object.
    public let videos: [OpenGraphVideo]
    /// A one to two sentence description of your object.
    public let description: String?
    /// The word that appears before this object's title in a sentence. Default is "" (blank).
    public let determiner : Determiner
    /// The locale these tags are marked up in. Of the format `language_TERRITORY`. Default is `en_US`.
    public let locale: String
    /// An array of other locales this page is available in.
    public let alternateLocales: [String]
    /// If your object is part of a larger web site, the name which should be displayed for the overall site. e.g., "IMDb".
    public let siteName: String?
    
    internal enum Constants {
        static let metaTag = "meta"
        
        static let propertyAttribute = "property"
        static let contentAttribute = "content"
        
        static let titleProperty = "og:title"
        static let urlProperty = "og:url"
        
        // TODO: Implement these
        // Optional properties
        static let audioProperty = "og:audio"
        static let descriptionProperty = "og:description"
        static let determinerProperty = "og:determiner"
        static let localeProperty = "og:locale"
        static let alternateLocaleProperty = "og:locale:alternate"
        static let siteNameProperty = "og:site_name"
        static let videoProperty = "og:video"
        
        // Default values
        static let defaultLocale = "en_US"
        static let defaultDeterminer = Determiner.blank
    }
    
    public init?(html: String)  {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            
            // Put all meta properties into a key-value pair array
            let parsed = try doc.select(Constants.metaTag).map({ element in
                _KeyValuePair(
                    key: try element.attr(Constants.propertyAttribute),
                    value: try element.attr(Constants.contentAttribute)
                )
            })
            
            func getFirstValue(for key: String) -> String? {
                parsed.first(where: { $0.key == key })?.value
            }
            
            // Find required single values title and url
            guard
                let title = getFirstValue(for: Constants.titleProperty),
                let url = getFirstValue(for: Constants.urlProperty) else {
                return nil
            }
            
            // Find images
            var images: [OpenGraphImage] = []
            var audios: [OpenGraphAudio] = []
            var videos: [OpenGraphVideo] = []
            for (index, kVP) in parsed.enumerated() {
                
                func getRemainingKVPs() -> [_KeyValuePair] {
                    Array(parsed[index+1..<parsed.count])
                }
                
                if OpenGraphImage.Constants.urlProperties.contains(kVP.key) {
                    images.append(
                        .init(
                            url: kVP.value,
                            followingProperties: getRemainingKVPs()
                        )
                    )
                }
                
                if OpenGraphAudio.Constants.urlProperties.contains(kVP.key) {
                    audios.append(.init(
                        url: kVP.value,
                        followingProperties: getRemainingKVPs()
                    ))
                }
                
                if OpenGraphVideo.Constants.urlProperties.contains(kVP.key) {
                    videos.append(.init(
                        url: kVP.value,
                        followingProperties: getRemainingKVPs()
                    ))
                }
            }
            
            // Make sure the first image exists
            guard let firstImage = images.removeFirstIfExists() else { return nil }
            
            // Decode the type from the given properties
            let type = OpenGraphType(kVPs: parsed)
            
            // Set properties
            self.title = title
            self.image = firstImage
            self.type = type
            self.url = url
            
            self.audios = audios
            self.videos = videos
            self.description = getFirstValue(for: Constants.descriptionProperty)
            self.determiner = Determiner(rawValue: getFirstValue(for: Constants.determinerProperty) ?? Constants.defaultDeterminer.rawValue) ?? Constants.defaultDeterminer
            self.siteName = getFirstValue(for: Constants.siteNameProperty)
            
            self.locale = getFirstValue(for: Constants.localeProperty) ?? Constants.defaultLocale
            self.alternateLocales = parsed.filter({ $0.key == Constants.alternateLocaleProperty }).map(\.value)
            
            self.additionalImages = images
        } catch let err {
            assertionFailure(err.localizedDescription)
            return nil
        }
    }
}
