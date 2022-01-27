//
//  MyInfoDetailVIewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/25.
//

import UIKit
import Firebase

class MyInfoDetailViewController : BaseViewController,UIScrollViewDelegate {
    //임시버튼
    let withdrawButton = UIButton()
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView()
        scrollView.backgroundColor = R.color.basicWhite()!
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()
    let myinfoView = MyInfoView()
    let specificView = MyInfoSpecificView()
    
    var collapse = false

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
        withdrawButton.setTitleColor(UIColor(resource: R.color.basicBlack), for: .normal)
        withdrawButton.setTitle("회원탈퇴", for: .normal)
        withdrawButton.titleLabel?.font = UIFont.toTitleR14
        withdrawButton.addTarget(self, action: #selector(withdrawButtonClicked(_:)), for: .touchUpInside)
        
        myinfoView.foldView.flipButton.addTarget(self, action: #selector(heightchange), for: .touchUpInside)
        
    }
    
    override func setUI() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(myinfoView)
        scrollView.addSubview(specificView)
        scrollView.addSubview(withdrawButton)
        
    }
    
    override func setConstraints() {
       
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        myinfoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(500)
        }
        
        specificView.snp.makeConstraints { make in
            make.top.equalTo(myinfoView.foldView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.bottom.equalTo(withdrawButton.snp.top)
        }
        
        withdrawButton.snp.makeConstraints { make in
            
            make.top.equalTo(specificView.agesLabel.snp.bottom).offset(40)
            make.leading.equalTo(0)
            make.width.equalTo(100)
            make.height.equalTo(60)
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
    
    @objc
    func heightchange(){
        print(collapse)
        collapse = !collapse
        
        if collapse {
            
            myinfoView.foldView.flipButton.setImage(UIImage(named: "moreArrow.svg"), for: .normal)
            
            self.myinfoView.foldView.titleView.snp.updateConstraints{ make in
                make.height.equalTo(0)
                
            }
            self.myinfoView.foldView.toHideView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self.myinfoView.foldView.snp.updateConstraints { make in
                make.height.equalTo(60)
                
            }
          
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        else {
            myinfoView.foldView.flipButton.setImage(UIImage(named: "noMoreArrow.svg"), for: .normal)
            
            self.myinfoView.foldView.snp.updateConstraints { make in
                make.height.equalTo(320)
            }
            
            self.myinfoView.foldView.toHideView.snp.updateConstraints { make in
                make.height.equalTo(240)
            }
            self.myinfoView.foldView.titleView.snp.updateConstraints{ make in
                make.height.equalTo(120)
                
            }
         
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
//extension MyInfoDetailViewController : UIScrollViewDelegate {
//
//}
