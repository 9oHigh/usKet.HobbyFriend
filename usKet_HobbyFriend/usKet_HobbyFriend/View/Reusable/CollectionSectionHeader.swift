//
//  InputHobbyHeaderView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/12.
//

import UIKit
import Then

class CollectionSectionHeader: UICollectionReusableView {
    
    static let identifier = "CollectionSectionHeader"
    
    let sectionHeaderlabel = UILabel().then {
        $0.font = .toTitleR12
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sectionHeaderlabel)
        
        sectionHeaderlabel.snp.makeConstraints { make in
            make.top.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
