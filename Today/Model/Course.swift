//
//  Courses.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import Foundation

struct Course: Identifiable, Codable {
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var user_id: String?
    var company_id: String?
    var title: String
}

extension [Course] {
    func indexOfCourse(withId id: Course.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension Course{
    static var sampleData: [Course] = [Course]()
}
#endif
