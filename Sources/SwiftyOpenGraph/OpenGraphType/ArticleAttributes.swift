import Foundation

extension OpenGraphType {
    
    public struct ArticleAttributes {
        /// When the article was first published.
        public let publishedTime: Date?
        /// When the article was last changed.
        public let modifiedTime: Date?
        /// When the article is out of date after.
        public let expirationTime: Date?
        /// Writers of the article.
        public let authors: [String]
        /// A high-level section name. E.g. Technology.
        public let section: String?
        /// Tag words associated with this article.
        public let tags: [String]
        
        internal enum Constants {
            static let type = "article"
            
            static let publishedTimeProperty = "article:published_time"
            static let modifiedTimeProperty = "article:modified_time"
            static let expirationTimeProperty = "article:expiration_time"
            static let authorProperty = "article:author"
            static let sectionProperty = "article:section"
            static let tagProperty = "article:tag"
        }
        
        init(properties: [_KeyValuePair]) {
            var publishedTimeString: String?
            var modifiedTimeString: String?
            var expirationTimeString: String?
            var authors: [String] = []
            var section: String?
            var tags: [String] = []
            
            for property in properties {
                switch property.key {
                case Constants.publishedTimeProperty:
                    publishedTimeString = property.value
                case Constants.modifiedTimeProperty:
                    modifiedTimeString = property.value
                case Constants.expirationTimeProperty:
                    expirationTimeString = property.value
                case Constants.authorProperty:
                    authors.append(property.value)
                case Constants.sectionProperty:
                    section = property.value
                case Constants.tagProperty:
                    tags.append(property.value)
                default:
                    break
                }
            }
            
            self.publishedTime = _getDate(from: publishedTimeString)
            self.modifiedTime = _getDate(from: modifiedTimeString)
            self.expirationTime = _getDate(from: expirationTimeString)
            self.authors = authors
            self.section = section
            self.tags = tags
        }
    }
}
