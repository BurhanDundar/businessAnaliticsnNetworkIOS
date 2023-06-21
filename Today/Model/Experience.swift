//
//  Experiences.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import Foundation

struct Experience: Identifiable,Codable {
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var user_id: String
    var name: String?
    var company_id: String
    var establishment: String
    var range: String?
    var location: String?
    var external: Bool?
    var subExperiences: [SubExperience]?
}

extension [Experience] {
    func indexOfExperience(withId id: Experience.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension Experience{
    static var sampleData: [Experience] = [] //[Skill]()
}
#endif
