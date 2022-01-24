//
//  HomeTabViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/23.
//

import UIKit
import Firebase

final class MyInfoViewController : UINavigationController {
    
    //이건 내 상세정보로 이동할 예정
    var withdrawButton = UIButton()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
    }
    
    func setConfigure(){
        
        title = "내정보"
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        //스크롤 불가능
        //tableView.alwaysBounceVertical = false
        
        //임시
        withdrawButton.setTitle("회원탈퇴", for: .normal)
        withdrawButton.tintColor = .blue
        withdrawButton.backgroundColor = .green
        withdrawButton.addTarget(self, action: #selector(withdrawButtonClicked(_:)), for: .touchUpInside)
    }
    
    func setUI(){
        view.addSubview(withdrawButton)
    }
    
    func setConstraints(){
        //임시
        withdrawButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func bind(){
        
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
