//
//  HomeTabViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/23.
//

import UIKit
import Firebase
class MyInfoViewController : UIViewController {
    
    var withdrawButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
    }
    
    func setConfigure(){
        
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
//        tabBarItem.image = UIImage(resource: R.image.tabPerson)!
//        tabBarItem.title = "내정보"
        withdrawButton.setTitle("회원탈퇴", for: .normal)
        withdrawButton.tintColor = .blue
        withdrawButton.backgroundColor = .green
        withdrawButton.addTarget(self, action: #selector(withdrawButtonClicked(_:)), for: .touchUpInside)
           
    }
    
    func setUI(){
        view.addSubview(withdrawButton)
    }
    
    func setConstraints(){
        withdrawButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func bind(){
        
    }
    @objc
    func withdrawButtonClicked(_ sender: UIButton){
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            guard let idToken = idToken else {
               print("회원탈퇴 에러")
                return
            }
            APIService.withdrawUser(idToken: idToken) { statusCode in
                LoginSingleTon().userReset()
                print("회원탈퇴 :",statusCode)
                if statusCode == 200 {
                    LoginSingleTon().registerUserData(userDataType: .startPosition, variableType: String.self, variable: "onboard")
                    self.transViewWithAnimation(isNavigation: false, controller: OnboardViewController())
                } else {
                    self.transViewWithAnimation(isNavigation: false, controller: OnboardViewController())
                }
            }
        }
    }
}
