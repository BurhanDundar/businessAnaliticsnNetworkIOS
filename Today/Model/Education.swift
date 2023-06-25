//
//  Educations.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import Foundation

struct Education: Identifiable, Codable {
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var company_id: String
    var user_id: String
    var establishment: String?
//    var department: String?
    var degree: String?
    var startDate: String?
    var endDate: String?
}

extension [Education] {
    func indexOfEducation(withId id: Education.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension Education{
    static var sampleData: [Education] = [Education]()
}
#endif
