import Foundation

extension OpenGraphType {
    
    public struct BookAttributes {
        /// Who wrote this book.
        public let author: String?
        /// The ISBN.
        public let isbn: String?
        /// The date the book was released.
        public let releaseDate: Date?
        /// Tag words associated with this book.
        public let tags: [String]
        
        internal enum Constants {
            static let type = "book"
            
            static let authorProperty = "book:author"
            static let isbnProperty = "book:isbn"
            static let releaseDateProperty = "book:release_date"
            static let tagProperty = "book:tag"
        }
        
        init(properties: [_KeyValuePair]) {
            var author: String?
            var isbn: String?
            var releaseDateString: String?
            var tags: [String] = []
            
            for property in properties {
                switch property.key {
                case Constants.authorProperty:
                    author = property.value
                case Constants.isbnProperty:
                    isbn = property.value
                case Constants.releaseDateProperty:
                    releaseDateString = property.value
                case Constants.tagProperty:
                    tags.append(property.value)
                default:
                    break
                }
            }
            
            self.author = author
            self.isbn = isbn
            self.releaseDate = _getDate(from: releaseDateString)
            self.tags = tags
        }
    }
}
