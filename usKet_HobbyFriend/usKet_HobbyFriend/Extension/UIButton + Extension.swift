//
//  UIButton + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//


import UIKit

extension UIButton {
        
    func fitToLogin(title : String){

        tintColor = UIColor(resource: R.color.basicWhite)
        backgroundColor = UIColor(resource: R.color.gray6)
        titleLabel?.font = UIFont.toBodyR14
        setTitle(title, for: .normal)
        layer.cornerRadius = 10
    }
}
