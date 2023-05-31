//
//  Experiences.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import Foundation

struct Experience: Codable {
    var _id: String? // aslında buna ihtiyaç yok
    var user_id: String
    var name: String?
    var company_id: String
    var establishment: String
    var range: String?
    var location: String?
    var subExperiences: [SubExperience]?
}
