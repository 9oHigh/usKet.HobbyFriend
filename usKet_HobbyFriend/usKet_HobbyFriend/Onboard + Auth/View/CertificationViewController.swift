//
//  CertificationViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit
import Rswift
import TextFieldEffects


class CertificationViewController : BaseViewController,UITextFieldDelegate {
    
    var informationLabel = UILabel()
    var textField = UITextField()
    var reciveButton = UIButton()
    var viewModel = CerViewModel()
    
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
        textField.delegate = self
        textField.backgroundColor = UIColor(resource: R.color.basicWhite)
        textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
        textField.placeholder = "휴대전화 번호(-없이 숫자만 입력)"
        
        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .touchUpInside)
        
        //MARK: 이유찾기 Button 반환 함수가 아닌 방법 찾기
        reciveButton.fitToLogin(title: "인증문자 받기")
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
        
        viewModel.validText.bind { phoneNumber in
            self.textField.text = phoneNumber
        }
        
        viewModel.validFlag.bind { toggle in
            self.reciveButton.isEnabled = toggle
        }
    }
    
    @objc
    func textFieldChanged(_ textField : UITextField){
        
        guard let text = textField.text else {
            return
        }
        
        if text == "" {
            textField.fitToLogin(color: UIColor(resource:R.color.gray3)!)
        }
        else {
            
            textField.fitToLogin(color: .black)
            
            textField.text = text.toPhoneNumberPattern(pattern: "###-####-####", replacmentCharacter: "#")
        }
        
        viewModel.validText.value = textField.text ?? ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.fitToLogin(color: .black)
    }
    
}

