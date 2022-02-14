//
//  NoFriendsView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/14.
//

import UIKit
import Then

protocol BasicView {
    func setUI()
    func setConstraints()
}

final class NoFriendsView: UIView, BasicView {
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = R.image.seSAC()!
        $0.tintColor = R.color.gray6()
    }
    
    let informLabel = UILabel().then {
        $0.textColor = R.color.basicBlack()
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let subInformLabel = UILabel().then {
        $0.textColor = R.color.gray6()
        $0.text = "취미를 변경하거나 조금더 기다려주세요!"
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = R.color.basicWhite()
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        addSubview(imageView)
        addSubview(informLabel)
        addSubview(subInformLabel)
    }
 
    func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
            make.bottom.equalTo(informLabel.snp.top).offset(-10)
        }
        
        informLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(subInformLabel.snp.top).offset(-10)
        }
        
        subInformLabel.snp.makeConstraints { make in
            make.top.equalTo(informLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}
