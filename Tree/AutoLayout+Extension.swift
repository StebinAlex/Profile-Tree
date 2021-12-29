//
//  AutoLayout+Extension.swift
//  Tree
//
//  Created by Stebin Alex on 29/12/21.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ array: [UIView]) {
        array.forEach { (l) in
            addArrangedSubview(l)
        }
    }
}

extension UIView {
    func anchorToSuperView(topPadding: CGFloat? = 0, bottomPadding: CGFloat? = 0, leftPadding: CGFloat? = 0, rightPadding: CGFloat? = 0 ) {
        if let constant = topPadding {
            topAnchor.constraint(equalTo: superview!.topAnchor, constant: constant).isActive = true
        }
        if let constant = bottomPadding {
            bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: constant).isActive = true
        }
        
        if let constant = leftPadding {
            leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: constant).isActive = true
        }
        
        if let constant = rightPadding {
            rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: constant).isActive = true
        }
    }
    
    func anchorToCenter(xPadding: CGFloat? = 0, yPadding: CGFloat? = 0,topPadding: CGFloat? = nil, bottomPadding: CGFloat? = nil, leftPadding: CGFloat? = nil, rightPadding: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        if let constant = topPadding {
            topAnchor.constraint(equalTo: superview!.topAnchor, constant: constant).isActive = true
        }
        if let constant = bottomPadding {
            bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: constant).isActive = true
        }
        
        if let constant = leftPadding {
            leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: constant).isActive = true
        }
        
        if let constant = rightPadding {
            rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: constant).isActive = true
        }
        
        if let constant = xPadding {
            centerXAnchor.constraint(equalTo: superview!.centerXAnchor, constant: constant).isActive = true
        }
        if let constant = yPadding {
            centerYAnchor.constraint(equalTo: superview!.centerYAnchor, constant: constant).isActive = true
        }
        if let constant = width {
            widthAnchor.constraint(equalToConstant: constant).isActive = true
        }
        if let constant = height {
            heightAnchor.constraint(equalToConstant: constant).isActive = true
        }
    }
}

