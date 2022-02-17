//
//  CerMessageViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit

final class CerMessageViewController: BaseViewController {
    
    var centerView = UIView()
    
    var informationLabel = UILabel()
    var subInfomationLabel = UILabel()
    var timerLabel = UILabel()
    
    var textField = UITextField()
    
    var certiButton = UIButton()
    var resendButton = UIButton()
    
    private var viewModel = CertificationViewModel()
    private var errorMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
        monitorNetwork()
        
        // 타이머 시작
        viewModel.startTimer()
        showToast(message: "인증번호를 보냈습니다.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hiddenNavBar()
        monitorNetwork()
    }
    
    override func setConfigure() {
        // centerView
        centerView.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        // Labels
        informationLabel.fitToLogin(text: "인증번호가 문자로 전송되었어요")
        subInfomationLabel.subfitToLogin(text: "(최대 소모 20초)")
        
        timerLabel.textColor = UIColor(resource: R.color.brandGreen)
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.toTitleM14
        timerLabel.text = "01:00"
        
        // TextField + FirstResponder : 키보드 바로 올라오게
        textField.becomeFirstResponder()
        textField.textContentType = .oneTimeCode // 자동완성
        textField.keyboardType = .numberPad // 숫자패드
        textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
        textField.placeholder = "인증번호 입력"
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        // Buttons
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
            // 바뀔때 마다 유효성 검사 -> 버튼
            self?.viewModel.cerValidate()
            
            // 텍스트필드 확인
            self?.textField.text = validNumber
            
            validNumber == "" ?  self?.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!) : self?.textField.fitToLogin(color: UIColor(resource: R.color.basicBlack)!)
        }
        
        viewModel.validFlag.bind { [weak self] sign in
            
            self?.certiButton.backgroundColor = sign ? UIColor(resource: R.color.brandGreen) : UIColor(resource: R.color.gray3)
            
            self?.certiButton.isEnabled = sign ? true : false
        }
        
        viewModel.timer.bind { [weak self] time in
            // 타이머 라벨
            if time == 0 {
                self?.timerLabel.text = "00:00"
                self?.showToast(message: "전화번호 인증 실패")
                self?.timerLabel.isHidden = true
            } else {
                self?.timerLabel.text = "00:\(time)"
            }
        }
        
        viewModel.errorMessage.bind { [weak self] error in
            self?.errorMessage = error
        }
        
    }
    
    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        guard let certiText = textField.text else { return }
        viewModel.validText.value = certiText.toCertiPattern(pattern: "######", replacmentCharacter: "#")
    }
    
    // 이런 addTarget같은 것들은 MVVM에서 사용하는게 맞는건가
    // 클릭이벤트 자체를 MVVM 패턴으로 활용할 수 있을까 그래서 RxSwift가 필요한건가 흐뮤뮤..
    @objc
    private func resendMessage(_ sender: UIButton) {
        
        viewModel.certificationPhone {
            
            if self.errorMessage == ""{
                // 타이머 재시작
                self.viewModel.timer.value = 60
                self.viewModel.startTimer()
                self.viewModel.validText.value = ""
                self.timerLabel.isHidden = false
                self.showToast(message: "인증번호를 재전송합니다")
    
            } else {
                // 에러 발생
                self.showToast(message: self.errorMessage)
            }
        }
    }
    
    @objc
    private func toHomeOrSign(_ sender: UIButton) {
        // MARK: ID토큰을 요청 -> (성공, 실패) / 성공시 서버에서 정보확인에 대해 성공과 미회원가입 처리
        viewModel.loginToFIR { success in
            
            guard success != nil else {
                self.showToast(message: self.errorMessage)
                return
            }
            self.viewModel.getIdToken { statusCode in
                
                DispatchQueue.main.async {
                    switch statusCode {
                        
                    case 200: // To Home
                        self.transViewWithAnimation(isNavigation: false, controller: HomeTabViewController())
                    
                    case 406: // To Nickname
                        self.transViewWithAnimation(isNavigation: true, controller: NicknameViewController())
                        
                    default :
                        self.showToast(message: self.errorMessage)
                    }
                }
            }
        }
    }
}
