//
//  UILabel + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit

extension UITextView {
    // MARK: 페센트로 바꿔주기
    func getLineHeight(text: String?, lineHeight: CGFloat) {
        
        guard let text = text, let font = self.font else {
            return
        }
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]
        
        let attrString = NSAttributedString(string: text,
                                            attributes: attributes)
        self.attributedText = attrString
    }
}
