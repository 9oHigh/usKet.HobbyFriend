//
//  CertificationViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit
import Rswift

class NicknameViewController : BaseViewController {
    
    var informationLabel = UILabel()
    var textField = UITextField()
    var nextButton = UIButton()
    var viewModel = CertificationViewModel()
    var errorMessage : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: 닉네임 인증 실패시 토스트 메세지 알림
        if errorMessage != "" {
            viewModel.refreshFCMtoken()
            self.showToast(message: errorMessage, font: UIFont.toBodyM16!, width: UIScreen.main.bounds.width * 0.8, height: 50)
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
        informationLabel.fitToLogin(text: "닉네임을 입력해주세요")
        
        //TextField
        textField.becomeFirstResponder()
        textField.delegate = self
        textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
        textField.placeholder = "10자 이내로 입력"
        
        //TextField Target
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        //Button
        nextButton.fitToLogin(title: "다음")
        nextButton.addTarget(self, action: #selector(toNextPage(_:)), for: .touchUpInside)
    }
    
    override func setUI() {
        
        view.addSubview(informationLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)
    }
    
    override func setConstraints() {
        
        informationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.4)
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
        
        viewModel.validText.bind { [weak self] nickName in
            //유효성검사
            self?.viewModel.nickValidate(nickName: nickName)
            //텍스트필드 확인
            nickName == "" ?  self?.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!) : self?.textField.fitToLogin(color: UIColor(resource:R.color.basicBlack)!)
        }
        
        viewModel.validFlag.bind { [weak self] sign in
            self?.nextButton.backgroundColor = sign ?
            UIColor(resource: R.color.brandGreen) : UIColor(resource: R.color.gray3)
            
            self?.nextButton.isEnabled = sign ?
            true : false
        }
        
        viewModel.errorMessage.bind { [weak self] error in
            self?.errorMessage = error
        }
    }
    
    @objc
    private func textFieldEditingChanged(_ textField : UITextField) {
        
        guard let nickName = textField.text else { return }
        
        viewModel.validText.value = nickName
    }
    
    @objc
    private func toNextPage(_ sender: UIButton){
        
        self.transViewController(nextType: .push, controller: BirthViewController())
    }
}

extension NicknameViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = (textField.text?.count)! + string.count - range.length
        return !(maxLength > 10)
    }
}
