//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by Burhan Dündar on 10.02.2023.
//

import UIKit

extension UserViewController {
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
