//
//  Company.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import Foundation

struct Company: Identifiable, Codable {
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var name: String
    var image: String?
    var type: String? // sonra enum olabilir
    var isBookmarked: Bool = false
}

extension [Company] {
    func indexOfCompany(withId id: Company.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}


#if DEBUG
extension Company{
    static var sampleData: [Company] = [Company]()
}
#endif
