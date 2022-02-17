//
//  CertificationViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit
import Firebase

final class GenderViewController: BaseViewController {
    
    var informationLabel = UILabel()
    var subInformationLabel = UILabel()
    
    var buttonView = UIView()
    var manButton = UIButton()
    var womanButton = UIButton()
    var nextButton = UIButton()
    
    var viewModel = CertificationViewModel()
    var errorMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gender = UserDefaults.standard.string(forKey: "gender") {
            viewModel.validText.value = gender
        }
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
        monitorNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hiddenNavBar()
        monitorNetwork()
    }
    
    override func setConfigure() {
        // View
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        // Information Label
        informationLabel.fitToLogin(text: "성별을 선택해주세요.")
        
        // subInform
        subInformationLabel.subfitToLogin(text: "새싹 찾기 기능을 이용하기 위해서 필요해요!")
        
        // buttonView
        buttonView.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        // Gender Buttons
        manButton.configuration  = .genderStyle(title: "남자", image: UIImage(resource: R.image.man)!)
        manButton.fitToGenderBorder()
        manButton.addTarget(self, action: #selector(backgourndColorChange(_:)), for: .touchUpInside)
        
        womanButton.configuration  = .genderStyle(title: "여자", image: UIImage(resource: R.image.woman)!)
        womanButton.fitToGenderBorder()
        womanButton.addTarget(self, action: #selector(backgourndColorChange(_:)), for: .touchUpInside)
        
        // Button
        nextButton.fitToLogin(title: "다음")
        nextButton.addTarget(self, action: #selector(toNextPage), for: .touchUpInside)
    }
    
    override func setUI() {
        
        view.addSubview(informationLabel)
        view.addSubview(subInformationLabel)
        
        view.addSubview(buttonView)
        buttonView.addSubview(manButton)
        buttonView.addSubview(womanButton)
        
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
        
        buttonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(115)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        manButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.95)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        womanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.95)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
    }
    
    override func bind() {
        
        viewModel.validText.bind { [weak self] gender in
            
            self?.viewModel.genderValidate()
            
            if gender == "0"{
                self?.womanButton.backgroundColor = UIColor(resource: R.color.brandWhitegreen)
            } else if gender == "1"{
                self?.manButton.backgroundColor = UIColor(resource: R.color.brandWhitegreen)
            } else {
                self?.womanButton.backgroundColor = UIColor(resource: R.color.basicWhite)
                self?.manButton.backgroundColor = UIColor(resource: R.color.basicWhite)
            }
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
    private func backgourndColorChange(_ sender: UIButton) {
        
        if sender == manButton {
            sender.backgroundColor = sender.backgroundColor == UIColor(resource: R.color.basicWhite) ? UIColor(resource: R.color.brandWhitegreen) : UIColor(resource: R.color.basicWhite)
            womanButton.backgroundColor = UIColor(resource: R.color.basicWhite)
            // 바인딩
            viewModel.validText.value = sender.backgroundColor == UIColor(resource: R.color.brandWhitegreen) ? "1" : "-1"
        } else {
            sender.backgroundColor = sender.backgroundColor == UIColor(resource: R.color.basicWhite) ? UIColor(resource: R.color.brandWhitegreen) : UIColor(resource: R.color.basicWhite)
            manButton.backgroundColor = UIColor(resource: R.color.basicWhite)
            // 바인딩
            viewModel.validText.value = sender.backgroundColor == UIColor(resource: R.color.brandWhitegreen) ? "0" : "-1"
        }
    }
    
    @objc
    private func toNextPage() {
        viewModel.signupToSeSAC { statusCode in
            
            DispatchQueue.main.async {
                
                switch statusCode {
                    
                case 200 : // 회원가입 성공, To home
                    self.transViewWithAnimation(isNavigation: false, controller: HomeTabViewController())
                    
                case 201 : // 이미 회원가입 되어있는 상태, To home
                    self.transViewWithAnimation(isNavigation: false, controller: HomeTabViewController())
                    
                case 202 : // 닉네임 오류
                    let nickNameViewController = NicknameViewController()
                    nickNameViewController.showToast(message: "다른 닉네임으로 변경해주세요")
                    self.transViewWithAnimation(isNavigation: true, controller: nickNameViewController)
                    
                default :
                    self.showToast(message: "오류 발생, 다시 시도해주세요.")
                }
            }
        }
    }
}
