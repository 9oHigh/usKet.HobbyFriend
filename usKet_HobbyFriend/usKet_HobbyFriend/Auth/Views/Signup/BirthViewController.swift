//
//  CertificationViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit

final class BirthViewController: BaseViewController {
    
    var informationLabel = UILabel()
    // middle View
    var dateFieldView = UIView()
    // 스택뷰로 넣어보자 다음에는!
    var yearView = DateTextView()
    var monthView = DateTextView()
    var dayView = DateTextView()
    
    var nextButton = UIButton()
    var datePicker = UIDatePicker()
    
    private var viewModel = CertificationViewModel()
    private var errorMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Before bind
        if let birth = UserDefaults.standard.string(forKey: "birth") {
            let birthDate = birth.toDate()
            viewModel.validText.value = birthDate.toOriginalString()
            viewModel.birthDate.value = birthDate.toStringEach()
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
        informationLabel.fitToLogin(text: "생년월일을 알려주세요")
        
        // dateFieldView
        let date = Date().toStringEach()
        dateFieldView.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        yearView.dateLabel.text = "년"
        yearView.textField.placeholder = date.0
        
        monthView.dateLabel.text = "월"
        monthView.textField.placeholder = date.1
        
        dayView.dateLabel.text = "일"
        dayView.textField.placeholder = date.2
        
        datePicker.backgroundColor = UIColor(resource: R.color.gray4)
        datePicker.becomeFirstResponder()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        // 입력해 놓은 데이터가 있다면 그 날짜에 피커뷰 맞춰주기
        datePicker.date = viewModel.birthDate.value == ("", "", "") ? Date() : viewModel.validText.value.toDate()
        datePicker.addTarget(self, action: #selector(dateFieldChanged(_:)), for: .valueChanged)
        
        // Button
        nextButton.fitToLogin(title: "다음")
        nextButton.addTarget(self, action: #selector(toNextPage(_:)), for: .touchUpInside)
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
            make.centerY.equalToSuperview().multipliedBy(0.4)
        }
        
        dateFieldView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
        // 스택뷰로 넣을걸!
        yearView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.trailing.equalTo(monthView.snp.leading).offset(-15)
        }
        
        monthView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.leading.equalTo(yearView.snp.trailing)
            make.trailing.equalTo(dayView.snp.leading).offset(-15)
        }
        
        dayView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
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
        
        viewModel.validText.bind { [weak self] _ in
            // 유효성 검사는 3개의 필드가 모두 변환되었을 때
            DispatchQueue.main.async {
                (self?.viewModel.checkFullDate())! ? self?.viewModel.birthValidate() : ()
            }
        }
        
        viewModel.validFlag.bind { [weak self] sign in
            
            self?.nextButton.backgroundColor = sign ?
            UIColor(resource: R.color.brandGreen) : UIColor(resource: R.color.gray3)
            
            self?.nextButton.isEnabled = sign ? true : false
        }
        
        viewModel.birthDate.bind { [weak self] (year, month, day) in
            // 각각 색이 바뀌게 만들어버렸다.. 그런거 없었는데.. 멍청..
            year != "" ? self?.yearView.textField.fitToLogin(color: UIColor(resource: R.color.basicBlack)!) : self?.yearView.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
            month != "" ? self?.monthView.textField.fitToLogin(color: UIColor(resource: R.color.basicBlack)!) : self?.monthView.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
            day != "" ? self?.dayView.textField.fitToLogin(color: UIColor(resource: R.color.basicBlack)!) : self?.dayView.textField.fitToLogin(color: UIColor(resource: R.color.gray3)!)
            
            self?.yearView.textField.text = year
            self?.monthView.textField.text = month
            self?.dayView.textField.text = day
        }
        
        viewModel.errorMessage.bind { [weak self] error in
            self?.errorMessage = error
        }
    }
    
    @objc
    private func dateFieldChanged(_ datePicker: UIDatePicker) {
        // MARK: 하나로 할 수 있을 것 같은데.. 두개로 할 필요없지 않나
        // 유저디포트에 저장할 값
        viewModel.validText.value = datePicker.date.toOriginalString()
        
        // 화면에 보여줄 값
        let pickerDate = datePicker.date.toStringEach()
        
        viewModel.prevDate.value.0 != pickerDate.0 ? viewModel.birthDate.value.0 = pickerDate.0 : ()
        viewModel.prevDate.value.1 != pickerDate.1 ? viewModel.birthDate.value.1 = pickerDate.1 : ()
        viewModel.prevDate.value.2 != pickerDate.2 ? viewModel.birthDate.value.2 = pickerDate.2 : ()

        // 변경된 값을 넣어주고 다시 비교할 수 있게
        viewModel.prevDate.value = pickerDate
    }
    
    @objc
    private func toNextPage(_ sender: UIButton) {
        
        errorMessage != "" ? self.showToast(message: errorMessage) : self.transViewController(nextType: .push, controller: EmailViewController())
    }
}
