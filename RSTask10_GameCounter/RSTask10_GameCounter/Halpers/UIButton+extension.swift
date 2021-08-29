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
    
    func createEllipseButton(title: String, font: UIFont, radius: CGFloat, shadow: Bool)->UIButton{
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(named: "tintColor")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        if shadow{
            self.titleLabel?.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
            self.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.titleLabel?.layer.shadowRadius = 0
            self.titleLabel?.layer.shadowOpacity = 1.0
        }
        return self
    }
    
    func onOffButton(enable: Bool){
        if enable{
            self.isEnabled = true
            self.alpha = 1
        } else {
            self.isEnabled = false
            self.alpha = 0.5
        }
    }
    
}
