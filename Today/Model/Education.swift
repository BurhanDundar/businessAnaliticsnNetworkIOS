//
//  Educations.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import Foundation

struct Education: Codable {
    var _id: String?
    var company_id: String
    var user_id: String
    var department: String?
    var degree: String?
    var startDate: String?
    var endDate: String?
}
