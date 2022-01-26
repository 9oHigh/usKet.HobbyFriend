//
//  MyInfoTableViewCell.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/27.
//

import UIKit

class MyInfoTableViewCell: UITableViewCell {

    
    static let identifier = "MyInfoTableViewCell"
    
    let profileView = ProfileNameView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure(){
        //profileView
        profileView.nameLabel.font = .toTitleM16
    }
    
    func setUI(){
        addSubview(profileView)
    }
    
    func setConstraints(){
        
        profileView.profileImageView.snp.makeConstraints { make in
            
            make.height.width.equalTo(20)
        }
        
        profileView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
    
    func setUpdate(myInfo : MyInfo){
        
        profileView.profileImageView.image = myInfo.image
        profileView.nameLabel.text = myInfo.name
    }
}
