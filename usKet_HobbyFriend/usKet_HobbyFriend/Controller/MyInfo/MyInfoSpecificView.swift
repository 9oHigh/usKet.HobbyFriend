//
//  MyInfoSpecificView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/28.
//

import UIKit

class MyInfoSpecificView : UIView {
    
    let viewModel = MyInfoViewModel()
    
    let views : [UIView] = {
        var views : [UIView] = []
        for item in 0...4 {
            let view = UIView()
            view.backgroundColor = R.color.basicWhite()!
            views.append(view)
        }
        return views
    }()
    
    let genderLabel : UILabel = {
        let label = UILabel()
        label.text = "내 성별"
        label.font = .toTitleR14
        return label
    }()
    let manButton : UIButton = {
        let button = UIButton()
        button.fitToGenderBorder()
        button.setTitleColor(R.color.basicBlack()!, for: .normal)
        button.setTitle("남자", for: .normal)
        button.titleLabel?.font = .toTitleR14
        return button
    }()
    let womanButton : UIButton = {
        let button = UIButton()
        button.fitToGenderBorder()
        button.setTitleColor(R.color.basicBlack()!, for: .normal)
        button.setTitle("여자", for: .normal)
        button.titleLabel?.font = .toTitleR14
        return button
    }()
    
    let hobbyLabel : UILabel = {
        let label = UILabel()
        label.text = "자주하는 취미"
        label.font = .toTitleR14
        return label
    }()
    let hobbyTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "아직없어요."
        textField.isEnabled = false
        textField.fitToLogin(color: R.color.gray3()!)
        return textField
    }()
    
    let permitNumber : UILabel = {
        let label = UILabel()
        label.text = "내 번호 검색허용"
        label.font = .toTitleR14
        return label
    }()
    let permitSwitch : UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.isOn = false
        return mySwitch
    }()
    
    let otherAgesLabel : UILabel = {
        let label = UILabel()
        label.text = "상대방 연령대"
        label.font = .toTitleR14
        return label
    }()
    let agesLabel : UILabel = {
        let label = UILabel()
        label.text = "18 - 35"
        label.textColor = R.color.brandGreen()!
        label.font = .toTitleR14
        return label
    }()
    let ageSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 65
        slider.thumbTintColor = R.color.brandGreen()!
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        views.forEach { view in
            addSubview(view)
        }
        
        views[0].addSubview(genderLabel)
        views[0].addSubview(manButton)
        views[0].addSubview(womanButton)
        
        views[1].addSubview(hobbyLabel)
        views[1].addSubview(hobbyTextField)
        
        views[2].addSubview(permitNumber)
        views[2].addSubview(permitSwitch)
        
        views[3].addSubview(otherAgesLabel)
        views[3].addSubview(agesLabel)
        views[3].addSubview(ageSlider)
    }
    
    func setConstraints(){
        //gender
        views[0].snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(60)
        }
        genderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(5)
        }
        womanButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-5)
            make.height.width.equalTo(50)
        }
        manButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(womanButton.snp.leading).offset(-5)
            make.height.width.equalTo(50)
        }
        
        //hobby
        views[1].snp.makeConstraints { make in
            make.top.equalTo(views[0].snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(60)
        }
        hobbyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(5)
        }
        hobbyTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-5)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        //permit
        views[2].snp.makeConstraints { make in
            make.top.equalTo(views[1].snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(60)
        }
        permitNumber.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(5)
        }
        permitSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-5)
            make.width.equalTo(44)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        //age
        views[3].snp.makeConstraints { make in
            make.top.equalTo(views[2].snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(80)
        }
        otherAgesLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.leading.equalTo(5)
        }
        agesLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.trailing.equalTo(-5)
        }
        ageSlider.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.trailing.leading.equalToSuperview().inset(5)
        }
    }
}
