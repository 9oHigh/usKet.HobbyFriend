//
//  FlipView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

//MARK: 전부 수정 해야함

import UIKit

class MyFoldView : UIView {
    
    var flipButton = UIButton() //펼치고 접을수 있는 버튼
    var nameLabel = UILabel()   //유저의 닉에임
    
    var toHideView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        return view
    }()
    
    var titleLabel = UILabel()  //새싹 타이틀
    var reviewTitle : ButtonsView = { //리뷰 타이틀 버튼
       let reviewTitle = ButtonsView()
        reviewTitle.translatesAutoresizingMaskIntoConstraints = false
        return reviewTitle
    }()
    
    var reviewLabel = UILabel() //새싹 리뷰
    var reviewOpenButton = UIButton() // 리뷰목록으로 이동
    var reviewTextView = UITextView() // 가장 먼저온 리뷰가 보일 곳
    
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
        
        addSubview(nameLabel)
        addSubview(flipButton)
        
        addSubview(toHideView)
        
        toHideView.addSubview(titleLabel)
        toHideView.addSubview(reviewTitle)
        
        toHideView.addSubview(reviewLabel)
        toHideView.addSubview(reviewOpenButton)
        toHideView.addSubview(reviewTextView)
    }
    
    func setConfigure(){
        
        nameLabel.text = UserDefaults.standard.string(forKey: "nick")
        nameLabel.font = UIFont.toTitleM16
        
        flipButton.setTitle("", for: .normal)
//        flipButton.setImage(UIImage(resource: ), for: .normal)
        
        titleLabel.font = UIFont.toTitleR12
        titleLabel.text = "새싹 타이틀"
        
        reviewLabel.text = "새싹 리뷰"
        reviewOpenButton.setImage(UIImage(resource: R.image.rightArrow), for: .normal)
        reviewOpenButton.isHidden = true
        
        reviewTextView.delegate = self
        reviewTextView.text = "첫리뷰를 기다리는 중이에요!"
        reviewTextView.textColor = UIColor(resource: R.color.gray6)
    }
    
    func setConstraints(){
        
    }
}
extension MyFoldView: UITextViewDelegate {
    
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor(resource: R.color.gray6) {
      textView.text = nil
        textView.textColor = UIColor(resource: R.color.basicBlack)
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "첫리뷰를 기다리는 중이에요!"
      textView.textColor = UIColor(resource: R.color.gray6)
    }
  }
}

class YourFlipView : MyFoldView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

