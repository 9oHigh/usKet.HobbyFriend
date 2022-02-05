//
//  FlipView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

import UIKit

final class MyInfoFoldView : UIView {

    //MARK: Fixed View
    let fixedView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        return view
    }()
    let nameLabel = UILabel()   //유저의 닉에임
    let flipButton = UIButton() //펼치고 접을수 있는 버튼
   
    //MARK: Hide View
    let toHideView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        return view
    }()
    
    let titleLabel = UILabel()  //새싹 타이틀
    let titleView : MyInfoCollectionVeiw = { //리뷰 타이틀 버튼
           let reviewTitle = MyInfoCollectionVeiw()
            reviewTitle.translatesAutoresizingMaskIntoConstraints = false
            return reviewTitle
        }()
    
    let reviewLabel = UILabel() //새싹 리뷰
    let reviewOpenButton = UIButton() // 리뷰목록으로 이동
    let reviewTextView = UITextView() // 가장 먼저온 리뷰가 보일 곳
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = R.color.gray3()?.cgColor
        
        nameLabel.text = UserDefaults.standard.string(forKey: "nick")
        nameLabel.font = .toTitleM16

        flipButton.setImage(UIImage(named: "noMoreArrow.svg")!, for: .normal)
        
        titleLabel.font = .toTitleR12
        titleLabel.text = "새싹 타이틀"
        
        reviewLabel.font = .toTitleR12
        reviewLabel.text = "새싹 리뷰"
        
        reviewOpenButton.setImage(UIImage(named: "noMoreArrow.svg")!, for: .normal)
        reviewOpenButton.isHidden = true
        
        reviewTextView.isEditable = false
        
        //MARK: RxSwift + TextView
        //reviewTextView -> RxSwift로
        //모델 -> 데이터(뷰모델에서 처리) -> 뷰
        reviewTextView.text = "첫리뷰를 기다리는 중이에요!"
        reviewTextView.textColor = UIColor(resource: R.color.gray6)
    }
    
    //MARK: 테이블뷰로 할걸!!! 으아아아!!!!
    func setConstraints(){
        //Height : 300
        fixedView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(60) // 고정높이.. 괴장히 나쁜..
            make.bottom.equalTo(toHideView.snp.top)
        }
        
        toHideView.snp.makeConstraints { make in
            make.top.equalTo(fixedView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(240) // 고정높이.. 굉장히 나쁘다그..
        }
        
        //Fixed View
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(0)
        }
        
        flipButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(0)
        }
        //Hide View
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(0)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(120) // 이친구도 고정높이네 👀
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
