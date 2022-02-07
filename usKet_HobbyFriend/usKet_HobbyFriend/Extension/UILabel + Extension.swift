//
//  UILabel + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit

extension UILabel {
    
    // MARK: multiple 적용
    func getLineHeightMultiple(text: String?, lineHeight: CGFloat, multiple: CGFloat) {
        
        guard let text = text else {
            return
        }
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.lineHeightMultiple = multiple
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]
        
        let attrString = NSAttributedString(string: text,
                                            attributes: attributes)
        self.attributedText = attrString
    }
    
    func toColored(text: String, target: String, color: UIColor) {
        
        let attributtedString = NSMutableAttributedString(string: text)
        attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: (text as NSString).range(of: target))
        self.attributedText = attributtedString
    }
    
    func fitToLogin(text: String) {
        
        self.numberOfLines = 0
        self.text = text
        self.textAlignment = .center
        self.textColor = UIColor(resource: R.color.basicBlack)
        self.font = UIFont.DisplayR20
    }
    
    func subfitToLogin(text: String) {
        
        self.numberOfLines = 0
        self.text = text
        self.textAlignment = .center
        self.textColor = UIColor(resource: R.color.gray7)
        self.font = UIFont.toTitleR16
    }
}
