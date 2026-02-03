import Foundation
import SwiftSoup
import AsyncNetworking

public enum OpenGraphError: Error {
    case invalidHTML
    case parsingFailed(String)
    case missingRequiredField(String)
}

public struct OpenGraph: Codable {
    /// The title of the page, taken from the standard <title> element (falling back to og:title).
    public let title: String
    /// The type of your object, e.g., "video.movie". Optional if it cannot be determined.
    public let type: OpenGraphType?
    /// The canonical URL of your object that will be used as its permanent ID in the graph, e.g., "https://www.imdb.com/title/tt0117500/".
    public let url: String
    
    /// All images included via Open Graph.
    public let images: [OpenGraphImage]
    
    /// Audio files to accompany this object.
    public let audios: [OpenGraphAudio]
    /// Video files that complement this object.
    public let videos: [OpenGraphVideo]
    /// A one to two sentence description of your object.
    public let itemDescription: String?
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
    
    public init?(url: String) async throws {
        guard
            let html =
                try await AsyncNetworking
                .request(
                    url: url,
                    options: [
                        .headerFields(value: [.userAgent: "Googlebot"]) // Some websites require this to return the open graph values
                    ]
                )
                .stringValue
        else {
            throw OpenGraphError.invalidHTML
        }
        
        try self.init(html: html)
    }
    
    public init?(html: String) throws {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            
            // Put all meta properties into a key-value pair array
            let parsed = try doc.select(Constants.metaTag).map { element in
                _KeyValuePair(
                    key: try element.attr(Constants.propertyAttribute),
                    value: try element.attr(Constants.contentAttribute)
                )
            }
            
            func getFirstValue(for key: String) -> String? {
                parsed.first(where: { $0.key == key })?.value
            }
            
            // og:title and og:url are required
            guard
                let ogTitle = getFirstValue(for: Constants.titleProperty),
                let url = getFirstValue(for: Constants.urlProperty)
            else { return nil }
            
            // Find images / audio / video
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
                    audios.append(
                        .init(
                            url: kVP.value,
                            followingProperties: getRemainingKVPs()
                        )
                    )
                }
                
                if OpenGraphVideo.Constants.urlProperties.contains(kVP.key) {
                    videos.append(
                        .init(
                            url: kVP.value,
                            followingProperties: getRemainingKVPs()
                        )
                    )
                }
            }
            
            // Decode the type from the given properties (now optional)
            let type = OpenGraphType(kVPs: parsed)
            
            // Set properties
            self.title = ogTitle
            self.type = type
            self.url = url
            
            self.audios = audios
            self.videos = videos
            self.itemDescription = getFirstValue(for: Constants.descriptionProperty)
            self.determiner = Determiner(
                rawValue: getFirstValue(for: Constants.determinerProperty)
                ?? Constants.defaultDeterminer.rawValue
            ) ?? Constants.defaultDeterminer
            self.siteName = getFirstValue(for: Constants.siteNameProperty)
            
            self.locale = getFirstValue(for: Constants.localeProperty) ?? Constants.defaultLocale
            self.alternateLocales = parsed
                .filter { $0.key == Constants.alternateLocaleProperty }
                .map(\.value)
            
            self.images = images
        } catch let error {
            throw OpenGraphError.parsingFailed(error.localizedDescription)
        }
    }
}
