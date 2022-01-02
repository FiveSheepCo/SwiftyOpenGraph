import Foundation

extension OpenGraphType.VideoAttributes {
    
    public struct Actor {
        public let url: String
        public let role: String?
        
        internal enum Constants {
            static let urlProperty = "video:actor"
            static let roleProperty = "video:actor:role"
        }
        
        init(url: String, followingProperties: [_KeyValuePair]) {
            var role: String? = nil
            
            loop: for property in followingProperties {
                switch property.key {
                case Constants.roleProperty:
                    role = property.value
                default:
                    // Break the for loop the first time a non-image property is found
                    if !property.key.starts(with: Constants.urlProperty) || property.key == Constants.urlProperty {
                        break loop
                    }
                }
            }
            
            self.url = url
            self.role = role
        }
    }
}
