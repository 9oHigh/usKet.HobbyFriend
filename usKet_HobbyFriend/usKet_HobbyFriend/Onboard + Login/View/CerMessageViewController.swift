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
        monitorNetwork()
        //타이머 시작
        viewModel.startTimer()
        self.showToast(message: "인증번호를 보냈습니다.", font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startTimer()
        monitorNetwork()
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
        textField.keyboardType = .numberPad // 숫자패드
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
            make.centerY.equalToSuperview().multipliedBy(0.4)
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
            
            self?.certiButton.backgroundColor = sign ? UIColor(resource: R.color.brandGreen) : UIColor(resource: R.color.gray3)
            
            self?.certiButton.isEnabled = sign ? true : false
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
    private func textFieldEditingChanged(_ textField : UITextField) {
        guard let certiText = textField.text else { return }
        viewModel.validText.value = certiText.toCertiPattern(pattern: "######", replacmentCharacter: "#")
    }
    
    @objc
    private func resendMessage(_ sender : UIButton){
        
        viewModel.certificationPhone {
            
            if self.errorMessage == ""{
                //바인딩되어있는 에러메세지가 값이 없다면
                //타이머도 다시
                self.viewModel.timer.value = 60
                self.viewModel.startTimer()
                self.viewModel.validText.value = ""
                self.showToast(message: "인증번호를 재전송합니다", font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
                
            } else {
                //에러 발생
                self.showToast(message: self.errorMessage, font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
            }
        }
    }
    
    @objc
    private func toHomeOrSign(_ sender : UIButton){
        //MARK: ID토큰을 요청 -> (성공, 실패) 분기처리 / 성공시 서버에서 정보확인에 대해 성공일경우와 201 경우 분기처리
        viewModel.loginToFIR { success in
            
            guard success != nil else {
                self.showToast(message: self.errorMessage, font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width*0.8, height: 50)
                return
            }
            self.viewModel.getIdToken { statusCode in
                
                DispatchQueue.main.async {
                    switch statusCode {
                    case 200: //To Home
                        self.transViewWithAnimation(isNavigation: false, controller: HomeViewController())
                    case 201: //To Nickname
                        self.transViewWithAnimation(isNavigation: true, controller: NicknameViewController())
                    default :
                        self.showToast(message: "오류 발생, 다시 시도해주세요.", font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width*0.8, height: 50)
                    }
                }
                
            }
        }
        
    }
}
