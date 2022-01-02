import Foundation

public struct OpenGraphVideo {
    public let url: String
    public let secureUrl: String?
    public let mimeType: String?
    public let width: Int?
    public let height: Int?
    public let alt: String?
    
    internal enum Constants {
        static let urlProperties = ["og:video", "og:video:url"]
        static let secureUrlProperty = "og:video:secure_url"
        static let mimeTypeProperty = "og:video:type"
        static let widthProperty = "og:video:width"
        static let heightProperty = "og:video:height"
        static let altProperty = "og:video:alt"
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
