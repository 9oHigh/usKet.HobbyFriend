//
//  InputHobbyCollectionViewCell.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/11.
//

import UIKit
import Then

final class InputHobbyCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "InputHobbyCollectionViewCell"
    
    let hobbyLabel = UILabel().then {
        $0.font = .toTitleR14
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(hobbyLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func matchUserColor(nameColor: UIColor, borderColor: UIColor) {
        
        hobbyLabel.textColor = nameColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        
        hobbyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func matchMyColor(color: UIColor = R.color.brandGreen()!) {
        
        hobbyLabel.textColor = color
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
        
        hobbyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
      
    }
}
