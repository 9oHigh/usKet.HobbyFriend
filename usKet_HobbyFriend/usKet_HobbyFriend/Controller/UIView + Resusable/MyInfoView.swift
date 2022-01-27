//
//  BackgroundFlipView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

import UIKit

class UserInfoView : UIView {
    
    let foldView = UserTitleFoldView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(foldView)
        
        foldView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
