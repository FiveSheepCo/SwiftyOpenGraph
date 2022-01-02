import Foundation

extension OpenGraphType {
    
    public struct ProfileAttributes {
        /// A name normally given to an individual by a parent or self-chosen.
        public let firstName: String?
        /// A name inherited from a family or marriage and by which the individual is commonly known.
        public let lastName: String?
        /// A short unique string to identify them.
        public let username: String?
        /// Their gender.
        public let gender: Gender?
        
        internal enum Constants {
            static let type = "article"
            
            static let firstNameProperty = "article:first_name"
            static let lastNameProperty = "article:last_name"
            static let usernameProperty = "article:username"
            static let genderProperty = "article:gender"
        }
        
        public enum Gender: String {
            case male, female
        }
        
        init(properties: [_KeyValuePair]) {
            var firstName: String?
            var lastName: String?
            var username: String?
            var gender: Gender?
            
            for property in properties {
                switch property.key {
                case Constants.firstNameProperty:
                    firstName = property.value
                case Constants.lastNameProperty:
                    lastName = property.value
                case Constants.usernameProperty:
                    username = property.value
                case Constants.genderProperty:
                    gender = Gender(rawValue: property.value)
                default:
                    break
                }
            }
            
            self.firstName = firstName
            self.lastName = lastName
            self.username = username
            self.gender = gender
        }
    }
}
