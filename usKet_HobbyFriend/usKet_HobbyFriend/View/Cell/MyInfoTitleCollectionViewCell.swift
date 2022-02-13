//
//  ButtonsView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

import UIKit

class MyInfoTitleCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "MyInfoTitleCollectionViewCell"
    let titleButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure() {
        
        titleButton.setTitleColor(UIColor(resource: R.color.basicBlack), for: .normal)
        titleButton.setTitle("", for: .normal)
        titleButton.backgroundColor = UIColor(resource: R.color.basicWhite)
        titleButton.titleLabel?.font = .toTitleR14
        
        titleButton.layer.cornerRadius = 10
        titleButton.layer.borderColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1).cgColor
        titleButton.layer.borderWidth = 1
    }
    
    func setUI() {
        
        addSubview(titleButton)
    }
    
    func setConstraints() {
        
        titleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setUpdate(myTitle: MyTitle) {
        
        titleButton.setTitle(myTitle.title, for: .normal)
    }
}