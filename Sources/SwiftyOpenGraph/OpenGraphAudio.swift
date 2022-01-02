import Foundation

public struct OpenGraphAudio {
    public let url: String
    public let secureUrl: String?
    public let mimeType: String?
    public let alt: String?
    
    internal enum Constants {
        static let urlProperties = ["og:audio", "og:audio:url"]
        static let secureUrlProperty = "og:audio:secure_url"
        static let mimeTypeProperty = "og:audio:type"
        static let altProperty = "og:audio:alt"
    }
    
    init(url: String, followingProperties: [_KeyValuePair]) {
        var secureUrl: String? = nil
        var mimeType: String? = nil
        var alt: String? = nil
        
        loop: for property in followingProperties {
            switch property.key {
            case Constants.secureUrlProperty:
                secureUrl = property.value
            case Constants.mimeTypeProperty:
                mimeType = property.value
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
        self.alt = alt
    }
}
