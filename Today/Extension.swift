//
//  Extension.swift
//  Today
//
//  Created by Burhan Dündar on 10.02.2023.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImageView {
    func loadImage(for stringURL: String){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                guard let url = URL(string: stringURL) else {
                    return
                }
                
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
            
                self.image = UIImage(data: data)
            }
        }
    }
}
