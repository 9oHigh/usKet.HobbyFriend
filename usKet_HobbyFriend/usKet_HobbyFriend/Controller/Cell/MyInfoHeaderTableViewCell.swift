//
//  MyInfoHeaderTableViewCell.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/27.
//

import UIKit

class MyInfoHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "MyInfoHeaderTableViewCell"
    
    let profileView = ProfileNameView()
    let nextButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure() {
        
        // profileView
        profileView.nameLabel.font = .toTitleM16
        
        // nextButton
        nextButton.setImage(R.image.rightArrow(), for: .normal)
        nextButton.setTitle("", for: .normal)
    }
    
    func setUI() {
        
        addSubview(profileView)
        addSubview(nextButton)
    }
    
    func setConstraints() {
     
        profileView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        profileView.profileImageView.snp.makeConstraints { make in
            
            make.height.width.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(10)
            make.height.width.equalTo(20)
            make.trailing.equalTo(-15)
        }
    }
    
    func setUpdate(myInfo: MyInfo) {
        
        profileView.profileImageView.image = myInfo.image
        profileView.nameLabel.text = myInfo.name
    }
}
