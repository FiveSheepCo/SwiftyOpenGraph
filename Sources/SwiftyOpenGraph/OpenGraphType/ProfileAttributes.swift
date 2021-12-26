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
