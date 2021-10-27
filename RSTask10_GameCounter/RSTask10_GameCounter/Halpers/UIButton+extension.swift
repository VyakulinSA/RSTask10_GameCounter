//
//  File.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import UIKit

extension UIButton{
    
    func createBarButton(title: String, font: UIFont)->UIButton{
        setTitle(title, for: .normal)
        titleLabel?.font = font
        setTitleColor(UIColor(named: "buttonColor"), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func createEllipseButton(title: String, font: UIFont, radius: CGFloat, shadow: Bool)->UIButton{
        setTitle(title, for: .normal)
        titleLabel?.font = font
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor(named: "buttonColor")
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = radius
        layer.masksToBounds = true
        if shadow{
            titleLabel?.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2)
            titleLabel?.layer.shadowRadius = 0
            titleLabel?.layer.shadowOpacity = 1.0
        }
        return self
    }
    
    func onOffButton(enable: Bool) {
        if enable{
            isEnabled = true
            setTitleColor(titleColor(for: .normal)?.withAlphaComponent(1.0), for: .normal)
        } else {
            isEnabled = false
            setTitleColor(titleColor(for: .normal)?.withAlphaComponent(0.5), for: .normal)
        }
    }
}
