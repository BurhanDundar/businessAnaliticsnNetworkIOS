//
//  ConnectAccountResponse.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 20.06.2023.
//

import Foundation

struct ConnectAccountResponse: Codable {
    var status: String
    var msg: String
    var userId: String
}
