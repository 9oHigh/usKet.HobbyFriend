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
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(510)
        }
        
        infoView.backgroundView.background.layer.cornerRadius = 15
        infoView.button.addTarget(self, action: #selector(requestFriend), for: .touchUpInside)
        
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc
    func requestFriend() {
        buttonAction()
    }
    
}
