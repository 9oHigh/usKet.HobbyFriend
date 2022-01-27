//
//  MyInfoTableViewCell.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/25.
//

import UIKit

final class ProfileNameView : UIView {
    
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    
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
        //SELF
        backgroundColor = UIColor(resource: R.color.basicWhite)
        
        //ImageView
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        nameLabel.backgroundColor = R.color.basicWhite()
        nameLabel.numberOfLines = 0
    }
    
    func setUI(){
        
        addSubview(profileImageView)
        addSubview(nameLabel)
    }
    
    func setConstraints(){
        
        profileImageView.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.equalTo(nameLabel.snp.leading).offset(-15)
        }
        
        nameLabel.snp.makeConstraints { make in
            
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing)
        }
    }

    func imageReSize(height: CGFloat, width: CGFloat){
        
        profileImageView.snp.makeConstraints { make in
            
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
}
