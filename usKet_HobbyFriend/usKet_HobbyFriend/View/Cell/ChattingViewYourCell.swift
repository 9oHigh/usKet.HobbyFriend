//
//  ChattingViewCell.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/21.
//

import UIKit
import Then

class ChattingViewYourCell: UITableViewCell {
    
    static let identifier = "ChattingViewYourCell"
    
    let messageBox = UITextView().then {
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.sizeToFit()
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.backgroundColor = R.color.basicWhite()!
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = R.color.basicBlack()!.cgColor
        $0.layer.borderWidth = 0.1
        $0.font = .toBodyR14
    }
    
    let date = UILabel().then {
        $0.numberOfLines = 0
        $0.backgroundColor = .clear
        $0.textColor = R.color.gray7()!
        $0.font = .toBodyR12
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(messageBox)
        contentView.addSubview(date)
        
        messageBox.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.bottom.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        
        date.snp.makeConstraints { make in
            make.leading.equalTo(messageBox.snp.trailing).offset(5)
            make.bottom.equalTo(messageBox.snp.bottom)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
