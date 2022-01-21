//
//  DateView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/22.
//


import UIKit

class DateTextView : UIView {

    var textField = UITextField()
    var dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure(){
        backgroundColor = UIColor(resource: R.color.basicWhite)
        textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
        
        dateLabel.textColor = UIColor(resource: R.color.basicBlack)
        dateLabel.backgroundColor = UIColor(resource: R.color.basicWhite)
        dateLabel.font = UIFont.toTitleR16
        dateLabel.textAlignment = .center
        
    }
    
    func setUI(){
        
        addSubview(textField)
        addSubview(dateLabel)
    }
    
    func setConstraints(){
        
        textField.snp.makeConstraints { make in
            
            make.top.left.bottom.equalToSuperview()
            make.trailing.equalTo(dateLabel.snp.leading)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(textField.snp.trailing)
        }
    }
}
