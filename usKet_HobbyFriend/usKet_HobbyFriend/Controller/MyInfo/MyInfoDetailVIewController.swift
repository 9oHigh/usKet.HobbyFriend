//
//  MyInfoDetailVIewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/25.
//

import UIKit
import Firebase

class MyInfoDetailViewController : BaseViewController {
    //임시버튼
    var withdrawButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "정보 관리"
        navigationController?.navigationBar.titleTextAttributes = [
            .font : UIFont.toTitleM14!,
            .foregroundColor : UIColor(resource: R.color.basicBlack)!
        ]
        
        setConfigure()
        setUI()
        setConstraints()
        monitorNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    override func setConfigure() {
        //임시
        withdrawButton.backgroundColor = UIColor(resource: R.color.basicWhite)
        withdrawButton.titleLabel?.font = UIFont.toTitleR14
        withdrawButton.setTitleColor(UIColor(resource: R.color.basicBlack), for: .normal)
        withdrawButton.setTitle("회원탈퇴", for: .normal)
        withdrawButton.addTarget(self, action: #selector(withdrawButtonClicked(_:)), for: .touchUpInside)
    }
    
    override func setUI() {
        
        view.addSubview(withdrawButton)
    }
    
    override func setConstraints() {
        
        withdrawButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-100)
            make.height.equalTo(50)
        }
    }

    //임시
    @objc
    func withdrawButtonClicked(_ sender: UIButton){
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            guard error == nil else {
                return
            }
            guard let idToken = idToken else {
                return
            }
            APIService.withdrawUser(idToken: idToken) { statusCode in
                SignupSingleton().userReset()
                
                DispatchQueue.main.async {
                    
                    if statusCode == 200 {
                        SignupSingleton().registerUserData(userDataType: .startPosition, variable: "onboard")
                        self.transViewWithAnimation(isNavigation: false, controller: OnboardViewController())
                        Messaging.messaging().token { fcmToken, error in
                            guard error == nil else {
                                return
                            }
                            guard let fcmToken = fcmToken else {
                                return
                            }
                            SignupSingleton().registerUserData(userDataType: .FCMtoken, variable: fcmToken)
                        }
                    } else {
                        self.transViewWithAnimation(isNavigation: false, controller: OnboardViewController())
                    }
                }
                
            }
        }
    }
}
