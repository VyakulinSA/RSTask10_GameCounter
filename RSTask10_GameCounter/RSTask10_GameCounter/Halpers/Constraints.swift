//
//  Constraints.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import Foundation
import UIKit


extension UIView {
    
    func fillSuperview(padding: UIEdgeInsets) {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding)
    }
    
    func fillSuperview() {
        fillSuperview(padding: .zero)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        var constraintsToActiveArray: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        if let top = top {
            constraintsToActiveArray.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        
        if let leading = leading {
            constraintsToActiveArray.append(leadingAnchor.constraint(equalTo: leading, constant: padding.left))
        }
        
        if let bottom = bottom {
            constraintsToActiveArray.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }
        
        if let trailing = trailing {
            constraintsToActiveArray.append(trailingAnchor.constraint(equalTo: trailing, constant: -padding.right))
        }
        
        if size.width != 0 {
            constraintsToActiveArray.append(widthAnchor.constraint(equalToConstant: size.width))
        }
        
        if size.height != 0 {
            constraintsToActiveArray.append(heightAnchor.constraint(equalToConstant: size.height))
        }
        
        guard constraintsToActiveArray.count > 0 else { return }
        
        NSLayoutConstraint.activate(constraintsToActiveArray)
        
    }
    
}

