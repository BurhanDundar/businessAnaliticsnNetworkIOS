//
//  Language.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import Foundation

struct Language: Identifiable, Codable{
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var title: String?
    var user_id: String
    var level: String?
}

extension [Language] {
    func indexOfLanguage(withId id: Language.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension Language{
    static var sampleData: [Language] = [Language]()
}
#endif
