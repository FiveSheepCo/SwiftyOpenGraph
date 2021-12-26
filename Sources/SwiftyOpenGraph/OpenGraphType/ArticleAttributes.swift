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
    
    public struct ArticleAttributes {
        /// When the article was first published.
        public let publishedTime: String?
        /// When the article was last changed.
        public let modifiedTime: String?
        /// When the article is out of date after.
        public let expirationTime: String?
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
            var publishedTime: String?
            var modifiedTime: String?
            var expirationTime: String?
            var authors: [String] = []
            var section: String?
            var tags: [String] = []
            
            for property in properties {
                switch property.key {
                case Constants.publishedTimeProperty:
                    publishedTime = property.value
                case Constants.modifiedTimeProperty:
                    modifiedTime = property.value
                case Constants.expirationTimeProperty:
                    expirationTime = property.value
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
            
            self.publishedTime = publishedTime
            self.modifiedTime = modifiedTime
            self.expirationTime = expirationTime
            self.authors = authors
            self.section = section
            self.tags = tags
        }
    }
}
