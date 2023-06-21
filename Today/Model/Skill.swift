//
//  Skill.swift
//  Today
//
//  Created by Burhan Dündar on 14.02.2023.
//

import Foundation

struct Skill: Identifiable,Codable {
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var title: String
    var user_id: String?
}

extension [Skill] {
    func indexOfSkill(withId id: Skill.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension Skill{
    static var sampleData: [Skill] = [Skill]()
}
#endif
