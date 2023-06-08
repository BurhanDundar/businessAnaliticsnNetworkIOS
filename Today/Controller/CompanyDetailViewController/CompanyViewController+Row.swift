//
//  CompanyViewController+Row.swift
//  Today
//
//  Created by Şerife Türksever on 8.06.2023.
//


import UIKit

extension CompanyViewController {
    enum Row: Hashable {
        case name
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .name: return .headline
            default: return .subheadline
            }
        }
    }
}
