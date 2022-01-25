//
//  MyInfoTableViewCell.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/25.
//

import UIKit

final class ProfileImageButtonView : UIView {
    
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var customButton = UIButton()
    
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
        nameLabel.backgroundColor = UIColor(resource: R.color.basicWhite)
        customButton.backgroundColor = UIColor(resource: R.color.basicWhite)
    }
    
    func setUI(){
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(customButton)
    }
    
    func setConstraints(){
        
        profileImageView.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.leading.equalTo(15)
            make.trailing.equalTo(nameLabel.snp.leading).offset(-15)
        }
        
        nameLabel.snp.makeConstraints { make in
            
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing)
        }
        
        customButton.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
        }
    }
    
    func buttonReSize(height: CGFloat, width: CGFloat){
        
        customButton.snp.makeConstraints { make in
            
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
    
    func imageReSize(height: CGFloat, width: CGFloat){
        
        profileImageView.snp.makeConstraints { make in
            
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
}
