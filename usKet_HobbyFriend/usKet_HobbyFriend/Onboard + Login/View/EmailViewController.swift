//
//  CertificationViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit
import Rswift

class EmailViewController : BaseViewController {
    
    var informationLabel = UILabel()
    var subInformationLabel = UILabel()
    
    var textField = UITextField()
    var nextButton = UIButton()
    var viewModel = CertificationViewModel()
    var errorMessage : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "email") != nil {
            let email = UserDefaults.standard.string(forKey: "email")
            viewModel.validText.value = email!
        }
        setConfigure()
        setUI()
        setConstraints()
        bind()
        monitorNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    override func setConfigure() {
        //View
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        //Information Label
        informationLabel.fitToLogin(text: "이메일을 입력해주세요")
        
        //subInform
        subInformationLabel.subfitToLogin(text: "휴대폰 번호 변경시 인증을 위해 사용해요")
        
        //TextField
        textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
        textField.placeholder = "SeSAC@email.com"
        textField.becomeFirstResponder()
        
        //TextField Target
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        //Button
        nextButton.fitToLogin(title: "다음")
        nextButton.addTarget(self, action: #selector(toNextPage), for: .touchUpInside)
    }
    
    override func setUI() {
        
        view.addSubview(informationLabel)
        view.addSubview(subInformationLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)
    }
    
    override func setConstraints() {
        
        informationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.4)
        }
        
        subInformationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(informationLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
    }
    
    override func bind() {
        
        viewModel.validText.bind { [weak self] email in
            //유효성검사
            self?.viewModel.emailValidate(email: email)
            
            //텍스트필드 확인
            email == "" ?  self?.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!) : self?.textField.fitToLogin(color: UIColor(resource:R.color.basicBlack)!)
            self?.textField.text = email
        }
        
        viewModel.validFlag.bind { [weak self] sign in
            self?.nextButton.backgroundColor = sign ?
            UIColor(resource: R.color.brandGreen) : UIColor(resource: R.color.gray3)
        }
        
        viewModel.errorMessage.bind { [weak self] error in
            self?.errorMessage = error
        }
    }
    
    @objc
    private func textFieldEditingChanged(_ textField : UITextField) {
        
        guard let email = textField.text else { return }
        
        viewModel.validText.value = email
    }
    
    @objc
    private func toNextPage(){
        if self.errorMessage != ""{
            self.showToast(message: self.viewModel.errorMessage.value, font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.9, height: 50)
        } else {
        self.transViewController(nextType: .push, controller: GenderViewController())
        }
    }
}

