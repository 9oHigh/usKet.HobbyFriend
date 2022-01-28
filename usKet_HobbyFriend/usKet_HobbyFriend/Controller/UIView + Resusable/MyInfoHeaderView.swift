//
//  MyInfoHeaderView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/27.
//

import UIKit

class MyInfoHeaderView : UIView {
    
    //MARK: ImageView + sesac
    //RxSwift 사용해서 바인딩 해둘것
    //모델 + 뷰모델 정리되면
    
    let background = UIImageView()
    let sesac = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        background.contentMode = .scaleAspectFit
        background.image = R.image.sesacbackground1()!
        background.clipsToBounds = true
        background.layer.cornerRadius = 15
        
        sesac.contentMode = .scaleAspectFit
        sesac.image = R.image.sesac_face_1()!
        
        addSubview(background)
        background.addSubview(sesac)
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesac.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.25)
            make.centerX.equalToSuperview()
            make.height.equalTo(150) // 고정 높이
            make.width.equalTo(150) // 고정 넓이
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
