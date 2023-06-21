//
//  LinkedInEmailModel.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 16.06.2023.
//

import Foundation

struct LinkedInEmailModel: Codable {
    let elements: [Element]
}

struct Element: Codable {
    let elementHandle: Handle
    let handle: String

    enum CodingKeys: String, CodingKey {
        case elementHandle = "handle~"
        case handle
    }
}

struct Handle: Codable {
    let emailAddress: String
}
