//
//  ChatMenu.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/21.
//

import UIKit
import Then

final class ChatMenuView: UIView {
    
    let reportButton = UIButton().then {
        $0.configuration = .menuStyle(title: "새싹 신고", image: R.image.siren()!)
        $0.layer.borderWidth = 0
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    let cancelButton = UIButton().then {
        $0.configuration = .menuStyle(title: "약속 취소", image: R.image.cancelMatch()!)
        $0.layer.borderWidth = 0
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    let reviewButton = UIButton().then {
        $0.configuration = .menuStyle(title: "리뷰 등록", image: R.image.write()!)
        $0.layer.borderWidth = 0
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = R.color.basicWhite()!
        setUI()
        setConstraints()
    }
    
    private func setUI() {

        addSubview(reportButton)
        addSubview(cancelButton)
        addSubview(reviewButton)
    }
    
    func setConstraints() {
        
        reportButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.4)
            make.centerY.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(75)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(75)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.6)
            make.centerY.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(75)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
