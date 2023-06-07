//
//  UserViewController+Row.swift
//  Today
//
//  Created by Şerife Türksever on 7.06.2023.
//

import UIKit

extension MemberViewController {
    enum Row: Hashable {
        case full_name
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .full_name: return .headline
            default: return .subheadline
            }
        }
    }
}
