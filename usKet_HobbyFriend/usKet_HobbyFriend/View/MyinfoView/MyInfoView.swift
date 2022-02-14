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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(foldView.snp.top)
        }
        
        foldView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300) // Total height : 300
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBtnColor(title: String, color: UIColor) {
        
        backgroundView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.trailing.equalTo(10)
            make.height.equalTo(60)
            make.width.equalTo(80)
        }
        
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        button.setTitleColor(R.color.basicWhite()!, for: .normal)
        button.backgroundColor = color
    }
}
