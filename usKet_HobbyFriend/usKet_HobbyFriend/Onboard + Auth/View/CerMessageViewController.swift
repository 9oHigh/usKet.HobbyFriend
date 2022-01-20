//
//  CerMessageViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import Foundation
import UIKit

class CerMessageViewController : BaseViewController {
    
    var centerView = UIView()
    
    var informationLabel = UILabel()
    var subInfomationLabel = UILabel()
    var timerLabel = UILabel()
    
    var textField = UITextField()
    
    var certiButton = UIButton()
    var resendButton = UIButton()
    
    var errorMessage : String = ""
    
    var viewModel = CertificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
        //타이머 시작
        viewModel.startTimer()
    }
    
    override func setConfigure() {
        //centerView
        centerView.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        //Labels
        informationLabel.fitToLogin(text: "인증번호가 문자로 전송되었어요")
        subInfomationLabel.subfitToLogin(text: "(최대 소모 20초)")
        
        timerLabel.textColor = UIColor(resource: R.color.brandGreen)
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.toTitleM14
        timerLabel.text = "01:00"
        
        //TextField + FirstResponder : 키보드 바로 올라오게
        textField.becomeFirstResponder()
        textField.textContentType = .oneTimeCode //자동완성
        textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
        textField.placeholder = "인증번호 입력"
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        //Buttons
        certiButton.fitToLogin(title: "인증하고 시작하기")
        certiButton.addTarget(self, action: #selector(toHomeOrSign(_:)), for: .touchUpInside)
        
        resendButton.fitToLogin(title: "재전송")
        resendButton.backgroundColor = UIColor(resource: R.color.brandGreen)
        resendButton.addTarget(self, action: #selector(resendMessage(_:)), for: .touchUpInside)
    }
    
    override func setUI() {
        
        view.addSubview(informationLabel)
        view.addSubview(subInfomationLabel)
        
        view.addSubview(centerView)
        centerView.addSubview(textField)
        centerView.addSubview(resendButton)
        textField.addSubview(timerLabel)
        
        view.addSubview(certiButton)
    }
    
    override func setConstraints() {
        
        informationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        subInfomationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(informationLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(resendButton.snp.leading).offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-5)
        }
        
        resendButton.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing)
            make.trailing.equalTo(0)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        certiButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
    }
    
    override func bind() {
        
        viewModel.validText.bind { [weak self] validNumber in
            //바뀔때 마다 유효성 검사 -> 버튼
            self?.viewModel.cerValidate(validNumber: validNumber)
            
            //텍스트필드 확인
            self?.textField.text = validNumber
            validNumber == "" ?  self?.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!) : self?.textField.fitToLogin(color: UIColor(resource:R.color.basicBlack)!)
        }
        
        viewModel.validFlag.bind { [weak self] sign in
            //유효하다면
            self?.certiButton.backgroundColor = sign ? UIColor(resource: R.color.brandGreen) : UIColor(resource: R.color.gray3)
        }
        
        viewModel.errorMessage.bind { [weak self] error in
            self?.errorMessage = error
        }
        
        viewModel.timer.bind { second in
            //타이머 라벨
            if second == 0 {
                self.timerLabel.text = "00:00"
                self.showToast(message: "전화번호 인증 실패", font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
            }
            else {
                self.timerLabel.text = "00:\(second)"
            }
        }
    }
    
    @objc
    func textFieldEditingChanged(_ textField : UITextField) {
        guard let certiText = textField.text else { return }
        viewModel.validText.value = certiText.toCertiPattern(pattern: "######", replacmentCharacter: "#")
    }
    
    @objc
    func resendMessage(_ sender : UIButton){
        viewModel.certificationPhone {
            
            if self.errorMessage == ""{
                //바인딩되어있는 에러메세지가 값이 없다면
                //타이머도 다시
                self.viewModel.timer.value = 60
                self.viewModel.startTimer()
                self.showToast(message: "인증번호를 재전송합니다", font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
                
            } else {
                //에러 발생
                self.showToast(message: self.errorMessage, font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
            }
        }
    }
    
    @objc
    func toHomeOrSign(_ sender : UIButton){
        
        
    }
}
