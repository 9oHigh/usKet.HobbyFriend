//
//  CertificationViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit
import Rswift

class CertificationViewController : BaseViewController {
    
    var informationLabel = UILabel()
    var textField = UITextField()
    var reciveButton = UIButton()
    var viewModel = CertificationViewModel()
    var errorMessage : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
    }
    
    override func setConfigure() {
        //View
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        //Information Label
        informationLabel.fitToLogin(text: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요")
        
        //TextField
        textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
        textField.placeholder = "휴대전화 번호(-없이 숫자만 입력)"
        
        //TextField Target
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        //Button
        reciveButton.fitToLogin(title: "인증문자 받기")
        reciveButton.addTarget(self, action: #selector(toReciveMessage), for: .touchUpInside)
    }
    
    override func setUI() {
        
        view.addSubview(informationLabel)
        view.addSubview(textField)
        view.addSubview(reciveButton)
    }
    
    override func setConstraints() {
        
        informationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
        
        reciveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
    }
    
    override func bind() {
        
        viewModel.validText.bind { [weak self] phoneNumber in
            //유효성검사
            self?.viewModel.phoneValidate(phoneNumber: phoneNumber)
            
            //텍스트필드 확인
            phoneNumber == "" ?  self?.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!) : self?.textField.fitToLogin(color: UIColor(resource:R.color.basicBlack)!)
        }
        
        viewModel.validFlag.bind { [weak self] sign in
            self?.reciveButton.backgroundColor = sign ?
            UIColor(resource: R.color.brandGreen) : UIColor(resource: R.color.gray3)
        }
        
        viewModel.errorMessage.bind { [weak self] error in
            self?.errorMessage = error
        }
    }
    
    @objc
    func textFieldEditingChanged(_ textField : UITextField) {
        
        guard let phoneNumber = textField.text else { return }
        
        textField.text = phoneNumber.count <= 12 ? phoneNumber.toPhoneNumberPattern(pattern: "###-###-####", replacmentCharacter: "#") :
        phoneNumber.toPhoneNumberPattern(pattern: "###-####-####", replacmentCharacter: "#")
        
        viewModel.validText.value = textField.text!.replacingOccurrences(of: "-", with: "")
    }
    
    @objc
    func toReciveMessage(){
        //유효한 형식인가
        switch viewModel.validFlag.value {
            //유효한 케이스
        case true:
            //인증문자 메소드 수행
            viewModel.certificationPhone {
                //바인딩되어있는 에러메세지가 값이 없다면
                if self.errorMessage == ""{
                    
                    self.showToast(message: "번호 인증을 시작합니다", font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.transViewController(nextType: .push, controller: CerMessageViewController())
                    }
                } else {
                    //에러 발생
                    self.showToast(message: self.errorMessage, font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
                }
            }
            //유효하지 않은 케이스
        case false:
            print("toReciveMessage NO: ",self.viewModel.validFlag.value)
            self.showToast(message: "잘못된 전화번호 형식입니다", font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.7, height: 50)
        }
    }
    
}

