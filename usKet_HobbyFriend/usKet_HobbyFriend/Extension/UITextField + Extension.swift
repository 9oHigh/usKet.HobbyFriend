//
//  TextField + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import Foundation
import UIKit

extension UITextField {
    
    func addBottomLine(color: UIColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func fitToLogin(color: UIColor) {
        
        addBottomLine(color: color)
        backgroundColor = UIColor(resource: R.color.basicWhite)
        textColor = .black
        font = UIFont.toTitleR14
    }
    
}
