/*
 See LICENSE folder for this sample’s licensing information.
 */

import Foundation

struct User: Identifiable,Codable{
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var full_name: String
    var title: String?
    var image: String?
    var about: String?
    var connection_count: String?
    var memberId: String?
    var location: String?
    var profileLink: String?
    var isBookmarked: Bool = false
}

extension [User] {
    func indexOfUser(withId id: User.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension User{
    static var sampleData: [User] = [User]()
}
#endif
