//
//  MyInfoSpecificView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/28.
//

import UIKit
import DoubleSlider

final class MyInfoSpecificView: UIView {
    
    let viewModel = MyInfoViewModel()
    
    let views: [UIView] = {
        var views: [UIView] = []
        for item in 0...4 {
            let view = UIView()
            view.backgroundColor = R.color.basicWhite()!
            views.append(view)
        }
        return views
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "내 성별"
        label.font = .toTitleR14
        return label
    }()
    let manButton: UIButton = {
        let button = UIButton()
        button.fitToGenderBorder()
        button.setTitleColor(R.color.basicBlack()!, for: .normal)
        button.setTitle("남자", for: .normal)
        button.titleLabel?.font = .toTitleR14
        button.addTarget(self, action: #selector(genderClicked(_:)), for: .touchUpInside)
        return button
    }()
    let womanButton: UIButton = {
        let button = UIButton()
        button.fitToGenderBorder()
        button.setTitleColor(R.color.basicBlack()!, for: .normal)
        button.setTitle("여자", for: .normal)
        button.titleLabel?.font = .toTitleR14
        button.addTarget(self, action: #selector(genderClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    let hobbyLabel: UILabel = {
        let label = UILabel()
        label.text = "자주하는 취미"
        label.font = .toTitleR14
        return label
    }()
    let hobbyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "취미를 입력해주세요!"
        textField.fitToLogin(color: R.color.gray3()!)
        return textField
    }()
    
    let permitNumber: UILabel = {
        let label = UILabel()
        label.text = "내 번호 검색허용"
        label.font = .toTitleR14
        return label
    }()
    let permitSwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.isOn = false
        return mySwitch
    }()
    
    let otherAgesLabel: UILabel = {
        let label = UILabel()
        label.text = "상대방 연령대"
        label.font = .toTitleR14
        return label
    }()
    let agesLabel: UILabel = {
        let label = UILabel()
        label.text = "18 - 35"
        label.textColor = R.color.brandGreen()!
        label.font = .toTitleR14
        return label
    }()
    let ageSlider: DoubleSlider = {
        let slider = DoubleSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.trackHighlightTintColor =  R.color.brandGreen()!
        slider.trackTintColor = R.color.gray6()!
        slider.thumbTintColor = R.color.brandGreen()!
        return slider
    }()
    var labels: [String] = {
        var labels: [String] = []
        for number in stride(from: 18, to: 65, by: 1) {
            labels.append("$\(number)")
        }
        return labels
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ageSlider.editingDidEndDelegate = self
        
        ageSlider.labelsAreHidden = true
        ageSlider.smoothStepping = true
        ageSlider.numberOfSteps = labels.count
        
        // 값을 받으면 설정할 것
        ageSlider.lowerValueStepIndex = 0
        ageSlider.upperValueStepIndex = labels.count - 1
        
        agesLabel.text = "\(ageSlider.lowerValueStepIndex + 18) - \(ageSlider.upperValueStepIndex + 19)"
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
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
    
    func setConstraints() {
        // gender
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
        
        // hobby
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
            make.width.equalTo(140)
        }
        
        // permit
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
        
        // age
        views[3].snp.makeConstraints { make in
            make.top.equalTo(views[2].snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(100)
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
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    @objc
    func genderClicked(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        if sender == manButton {
            sender.backgroundColor = sender.backgroundColor == R.color.basicWhite()! ? R.color.brandGreen()! : R.color.basicWhite()!
            if sender.backgroundColor == R.color.basicWhite()! {
                sender.setTitleColor(R.color.basicBlack()!, for: .normal)
                userDefaults.set(-1, forKey: "gender")
            } else {
                sender.setTitleColor(R.color.basicWhite()!, for: .normal)
                userDefaults.set(1, forKey: "gender")
            }
            womanButton.backgroundColor = R.color.basicWhite()!
            womanButton.setTitleColor(R.color.basicBlack()!, for: .normal)
            
        } else {
            sender.backgroundColor = sender.backgroundColor == R.color.basicWhite()! ? R.color.brandGreen()! : R.color.basicWhite()!
            if sender.backgroundColor == R.color.basicWhite()! {
                sender.setTitleColor(R.color.basicBlack()!, for: .normal)
                userDefaults.set(-1, forKey: "gender")
            } else {
                sender.setTitleColor(R.color.basicWhite()!, for: .normal)
                userDefaults.set(0, forKey: "gender")
            }
            manButton.backgroundColor = R.color.basicWhite()!
            manButton.setTitleColor(R.color.basicBlack()!, for: .normal)
        }
    }
}
extension MyInfoSpecificView: DoubleSliderEditingDidEndDelegate {
    func editingDidEnd(for doubleSlider: DoubleSlider) {
        // 값이 변환되었을 때 보내주자!
        let startAge = doubleSlider.lowerValueStepIndex + 18
        let lastAge = doubleSlider.upperValueStepIndex + 19
        
        agesLabel.text = "\(startAge) - \(lastAge)"
        
        UserDefaults.standard.set(startAge, forKey: "ageMin")
        UserDefaults.standard.set(lastAge, forKey: "ageMax")
    }
}
