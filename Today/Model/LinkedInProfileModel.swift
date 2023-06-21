//
//  LinkedInProfileModel.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 16.06.2023.
//

import Foundation

struct LinkedInProfileModel: Codable {
    let firstName, lastName: StName
    let profilePicture: ProfilePicture?
    let id: String
}

struct StName: Codable {
    let localized: Localized
    var preferredLocale: PreferredLocale
}

struct Localized: Codable {
    let enUS: String

    enum CodingKeys: String, CodingKey {
        case enUS = "tr_TR"
    }
}
struct PreferredLocale: Codable {
    var country: String
    var language: String
}
struct ProfilePicture: Codable {
    let displayImage: DisplayImage

    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage~"
    }
}

// MARK: - DisplayImage
struct DisplayImage: Codable {
    let elements: [ProfilePicElement]
}

// MARK: - Element
struct ProfilePicElement: Codable {
    let identifiers: [ProfilePicIdentifier]
}

// MARK: - Identifier
struct ProfilePicIdentifier: Codable {
    let identifier: String
}


