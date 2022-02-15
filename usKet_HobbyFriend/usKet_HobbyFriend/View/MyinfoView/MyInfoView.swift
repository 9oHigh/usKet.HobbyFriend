//
//  BackgroundFlipView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

import UIKit

final class MyInfoView: UIView {
    
    let backgroundView = MyInfoHeaderView()
    let foldView = MyInfoFoldView()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(backgroundView)
        addSubview(foldView)
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(foldView.snp.top)
        }
        
        foldView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(300) // Total height : 300
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBtnColor(title: String, color: UIColor) {
        
        backgroundView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(44)
            make.width.equalTo(88)
        }
        
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        button.setTitleColor(R.color.basicWhite()!, for: .normal)
        button.titleLabel?.font = .toTitleM14
        button.backgroundColor = color
    }
}
