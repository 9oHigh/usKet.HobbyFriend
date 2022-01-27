//
//  FlipView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

//MARK: 전부 수정 해야함

import UIKit

class UserTitleFoldView : UIView {
    
    
    var fixedView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        return view
    }()
    var nameLabel = UILabel()   //유저의 닉에임
    var flipButton = UIButton() //펼치고 접을수 있는 버튼
   
    //Heiht Constraint = collapse ? 0 : Value
    var toHideView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        return view
    }()
    
    var titleLabel = UILabel()  //새싹 타이틀
    var titleView = TitleStackView()
    
    var reviewLabel = UILabel() //새싹 리뷰
    var reviewOpenButton = UIButton() // 리뷰목록으로 이동
    var reviewTextView = UITextView() // 가장 먼저온 리뷰가 보일 곳
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = R.color.gray6()?.cgColor
        
        setConfigure()
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        addSubview(fixedView)
        fixedView.addSubview(nameLabel)
        fixedView.addSubview(flipButton)
        
        addSubview(toHideView)
        toHideView.addSubview(titleLabel)
        toHideView.addSubview(titleView)
        
        toHideView.addSubview(reviewLabel)
        toHideView.addSubview(reviewOpenButton)
        toHideView.addSubview(reviewTextView)
    }
    
    func setConfigure(){
        
        nameLabel.text = UserDefaults.standard.string(forKey: "nick")
        nameLabel.font = UIFont.toTitleM16

        flipButton.setImage(R.image.rightArrow()!, for: .normal)
        
        titleLabel.font = UIFont.toTitleR12
        titleLabel.text = "새싹 타이틀"
        
        reviewLabel.text = "새싹 리뷰"
        reviewOpenButton.setImage(UIImage(resource: R.image.rightArrow), for: .normal)
        reviewOpenButton.isHidden = true
        
        reviewTextView.isEditable = false
        reviewTextView.text = "첫리뷰를 기다리는 중이에요!"
        reviewTextView.textColor = UIColor(resource: R.color.gray6)
    }
    
    func setConstraints(){
        
        fixedView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(toHideView.snp.top).offset(15)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(0)
        }
        
        flipButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(0)
        }
        
        toHideView.snp.makeConstraints { make in
            make.top.equalTo(fixedView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(0)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(120)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(15)
            make.leading.equalTo(0)
        }
        
        reviewOpenButton.snp.makeConstraints { make in
            make.centerY.equalTo(reviewLabel)
            make.trailing.equalTo(0)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
    }
    
    func setHideViewHeight(){ // bottomConstraints = 제거, hegiht = 0
        
    }
}
