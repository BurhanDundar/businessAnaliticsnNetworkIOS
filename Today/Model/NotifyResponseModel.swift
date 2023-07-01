//
//  NotifyResponseModel.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 1.07.2023.
//

import Foundation

struct NotifyResponseModel: Codable {
    var status: String
    var actionType: String
    var msg: String
}
