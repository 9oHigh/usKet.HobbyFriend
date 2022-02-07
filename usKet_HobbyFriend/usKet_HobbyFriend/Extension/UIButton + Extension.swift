//
//  UIButton + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit

extension UIButton {
        
    func fitToLogin(title: String) {

        tintColor = UIColor(resource: R.color.basicWhite)
        backgroundColor = UIColor(resource: R.color.gray6)
        titleLabel?.font = UIFont.toBodyR14
        setTitle(title, for: .normal)
        layer.cornerRadius = 10
    }
    
    func fitToGenderBorder() {
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1).cgColor
        
        // + Font / backgound
        titleLabel?.font = UIFont.toTitleR16
        backgroundColor = UIColor(resource: R.color.basicWhite)
    }
}

extension UIButton.Configuration {
    
    static func genderStyle(title: String, image: UIImage) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        
        config.title = title
        config.baseForegroundColor = UIColor(resource: R.color.basicBlack)
        config.titleAlignment = .center
        
        config.image = image
        config.imagePlacement = .top
        config.cornerStyle = .medium
        
        return config
    }
}
