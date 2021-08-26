//
//  UITextField+extension.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 26.08.2021.
//

import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
