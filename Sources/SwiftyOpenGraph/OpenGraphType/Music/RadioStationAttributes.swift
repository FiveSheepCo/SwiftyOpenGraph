import Foundation

extension OpenGraphType {
    
    public struct RadioStationAttributes {
        /// The creator of this station.
        public let creator: String?
        
        enum Constants {
            static let type = "music.radio_station"
            
            static let creatorProperty = "music:creator"
        }
        
        init(properties: [_KeyValuePair]) {
            var creator: String?
            
            for property in properties {
                switch property.key {
                case Constants.creatorProperty:
                    creator = property.value
                default:
                    break
                }
            }
            
            self.creator = creator
        }
    }
}
