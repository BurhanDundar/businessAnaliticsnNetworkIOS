//
//  Member.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 2.06.2023.
//

import Foundation

struct Member: Identifiable, Codable {
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var fullname: String
    var username: String
    var password: String?
    var email: String
    var createdAt: Int?
    var updatedAt: Int?
    var isBookmarked: Bool = false
    var userId: String?
}

extension [Member] {
    func indexOfMember(withId id: Member.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension Member{
    static var sampleData: [Member] = [Member]()
}
#endif
