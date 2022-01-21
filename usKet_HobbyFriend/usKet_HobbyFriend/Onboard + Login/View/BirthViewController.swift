//
//  CertificationViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit
import Rswift

class BirthViewController : BaseViewController {
    
    var informationLabel = UILabel()
    //middle View
    var dateFieldView = UIView()
    //스택뷰로 넣어보자 다음에는!
    var yearView = DateTextView()
    var monthView = DateTextView()
    var dayView = DateTextView()
    
    var nextButton = UIButton()
    var datePicker = UIDatePicker()
    
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
        informationLabel.fitToLogin(text: "생년월일을 알려주세요")

        //dateFieldView
        dateFieldView.backgroundColor = UIColor(resource: R.color.basicWhite)
        yearView.dateLabel.text = "년"
        monthView.dateLabel.text = "월"
        dayView.dateLabel.text = "일"
        
        datePicker.backgroundColor = UIColor(resource: R.color.gray4)
        datePicker.becomeFirstResponder()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(dateFieldChanged(_:)), for: .valueChanged)

        //Button
        nextButton.fitToLogin(title: "다음")
        nextButton.addTarget(self, action: #selector(nextPage(_:)), for: .touchUpInside)
    }
    
    override func setUI() {
        
        view.addSubview(informationLabel)
        
        view.addSubview(dateFieldView)
        dateFieldView.addSubview(yearView)
        dateFieldView.addSubview(monthView)
        dateFieldView.addSubview(dayView)
        
        view.addSubview(nextButton)
        view.addSubview(datePicker)
    }
    
    override func setConstraints() {
        
        informationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }

        dateFieldView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
        //스택뷰로 넣을걸!
        yearView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
            make.trailing.equalTo(monthView.snp.leading)
        }
        
        monthView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
            make.leading.equalTo(yearView.snp.trailing)
            make.trailing.equalTo(dayView.snp.leading)
        }
        
        dayView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
            make.leading.equalTo(monthView.snp.trailing)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(48)
        }
        
        datePicker.snp.makeConstraints { make in
            
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(nextButton.snp.bottom).offset(50)
        }
        
    }
    
    override func bind() {
        
//        viewModel.validText.bind { [weak self] phoneNumber in
//            //유효성검사
//            self?.viewModel.phoneValidate(phoneNumber: phoneNumber)
//
//            //텍스트필드 확인
//            phoneNumber == "" ?  self?.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!) : self?.textField.fitToLogin(color: UIColor(resource:R.color.basicBlack)!)
//        }
//
//        viewModel.validFlag.bind { [weak self] sign in
//            self?.nextButton.backgroundColor = sign ?
//            UIColor(resource: R.color.brandGreen) : UIColor(resource: R.color.gray3)
//        }
//
//        viewModel.errorMessage.bind { [weak self] error in
//            self?.errorMessage = error
//        }
    }
    
    @objc
    func dateFieldChanged(_ datePicker : UIDatePicker) {
        //유저디포트에 저장할 값
        viewModel.validText.value = datePicker.date.toOriginalString()
        //화면에 보여줄 값

       
    }

    @objc
    func nextPage(_ sender: UIButton){
        //self.transViewController(nextType: .push, controller: EmailViewController())
    }
    
}

