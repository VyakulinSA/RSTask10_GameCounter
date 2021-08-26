//
//  File.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import UIKit

extension UIButton{
    
    func createBarButton(title: String, font: UIFont)->UIButton{
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(UIColor(named: "tintColor"), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        return self
    }
    
}
