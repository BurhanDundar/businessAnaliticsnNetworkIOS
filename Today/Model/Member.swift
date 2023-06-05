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
    var name: String?
    var surname: String?
    var username: String?
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
