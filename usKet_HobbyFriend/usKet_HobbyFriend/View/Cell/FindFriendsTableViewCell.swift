//
//  ArroundViewCell.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/15.
//

import UIKit

class FindFriendsTableViewCell: UITableViewCell {
    
    static var identifier = "FindFriendsTableViewCell"
    var infoView = MyInfoView()
    var buttonAction : (() -> Void) = {}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(infoView)
        
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
