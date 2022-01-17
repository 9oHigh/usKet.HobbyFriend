//
//  ViewController.swift
//  usKet_Friend
//
//  Created by 이경후 on 2022/01/17.
//

import UIKit
import SnapKit
import FirebaseAuth

class ViewController: UIViewController {

    var checkButton = UIButton()
    var phoneNumberTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(checkButton)
        view.addSubview(phoneNumberTextField)
        
        checkButton.backgroundColor = .black
        checkButton.tintColor = .white
        checkButton.setTitle("인증", for: .normal)
        
        phoneNumberTextField.backgroundColor = .systemGray6
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.placeholder = "전화번호 입력"
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(20)
            make.top.equalTo(100)
            make.bottom.equalTo(checkButton.snp.top).offset(-30)
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.top.equalTo(phoneNumberTextField.snp.bottom)
        }
        
        checkButton.addTarget(self, action: #selector(sendVarification), for: .touchUpInside)
    }
    
    @objc func sendVarification(){
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTextField.text ?? "", uiDelegate: nil) { varification, error in
            if error == nil {
                print("SUCCESS")
            } else {
                print("FAILED")
            }
            
        }
        
    }

    
}

