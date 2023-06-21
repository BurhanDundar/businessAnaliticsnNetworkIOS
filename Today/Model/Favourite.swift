//
//  Favourite.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 10.06.2023.
//

import Foundation

struct Favourite: Identifiable,Codable{
    var _id: String? = UUID().uuidString
    var id: String? { _id }
    var user_id: String?
    var fav_id: String?
    var fav_type: String?
}
