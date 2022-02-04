//
//  MyInfoViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

import UIKit
import RxRelay
import RxSwift
import Firebase

final class MyInfoViewModel {
    
    var errorMessage = ""
    var user : User? = nil
    //BehaviorSubject는 초기값을 가지고 있는 subject
    // +subscribe가 발생하면, 발생한 시점 이전에 발생한 이벤트 중 가장 최신의 이벤트를 전달받는다. (다시 말하면 지속적으로 이벤트를 하나이상은 가지고 있게 되는 케이스)
    
    var myInfoMenu = BehaviorSubject<[MyInfo]>(value: [
        MyInfo(image: R.image.profileImg()!, name: UserDefaults.standard.string(forKey: "nick")!),
        MyInfo(image: R.image.notice()!, name: "공지사항"),
        MyInfo(image: R.image.qna()!, name: "자주 묻는 질문"),
        MyInfo(image: R.image.faq()!, name: "1:1 문의"),
        MyInfo(image: R.image.setting_alarm()!, name: "알림 설정"),
        MyInfo(image: R.image.permit()!, name: "이용 약관")
    ])
    
    var myInfoTitle = BehaviorSubject<[MyTitle]>(value: [
        MyTitle(title: "좋은 매너"),
        MyTitle(title: "정확한 시간 약속"),
        MyTitle(title: "빠른 응답"),
        MyTitle(title: "친절한 성격"),
        MyTitle(title: "능숙한 취미 실력"),
        MyTitle(title: "유익한 시간")
    ])
    
    func resetUserInfo(onCompletion : @escaping (Bool,String?)->Void){
        
        SignupSingleton.shared.getIdToken { idToken in
            guard let idToken = idToken else {
                self.errorMessage = "계정정보를 가지고 오는데 실패했습니다."
                onCompletion(false,self.errorMessage)
                return
            }
           
            APIService.withdrawUser(idToken: idToken) { statusCode in
                
                DispatchQueue.main.async {
                    
                    if statusCode == 200 {
                        
                        SignupSingleton.shared.userReset()
                        
                        SignupSingleton.shared.registerUserData(userDataType: .startPosition, variable: "onboard")
                        
                        Messaging.messaging().token { fcmToken, error in
                            guard error == nil else {
                                return
                            }
                            guard let fcmToken = fcmToken else {
                                return
                            }
                            SignupSingleton.shared.registerUserData(userDataType: .FCMtoken, variable: fcmToken)
                            
                            onCompletion(true,nil)
                        }
                    } else {
                        self.errorMessage = "회원탈퇴에 실패했습니다."
                        onCompletion(false,self.errorMessage)
                    }
                }
            }
        }
    }
    
    func getUserInfo(onCompletion : @escaping (User?,String?)->Void){
        
        SignupSingleton.shared.getIdToken { idToken in
            guard let idToken = idToken else {
                self.errorMessage = "정보를 가지고 오는데 실패했습니다."
                return
            }
            UserDefaults.standard.set(idToken, forKey: "idToken")
            APIService.getUser(idToken: idToken) { user, statusCode in
                
                guard let statusCode = statusCode else {
                    return
                }
                guard let user = user else {
                    self.errorMessage = "정보를 가지고 오는데 실패했습니다."
                    onCompletion(nil,self.errorMessage)
                    return
                }
                if statusCode == 200 {
                    
                    onCompletion(user,nil)
                } else if statusCode == 401 {
                    
                    DispatchQueue.main.async {
                        APIService.updateFCMtoken(idToken: idToken) { checked in
                            self.errorMessage = checked ? "정보를 갱신중입니다. 다시 요청해주세요." : "정보를 가지고 오는데 실패했습니다."
                        }
                    }
                    onCompletion(nil,self.errorMessage)
                } else if statusCode == 406 {
                    
                    self.errorMessage = "미가입 회원입니다."
                    SignupSingleton.shared.registerUserData(userDataType: .startPosition, variable: "onboard")
                    //뷰에서 루트뷰 온보드로 변경
                    onCompletion(nil,self.errorMessage)
                } else {
                    self.errorMessage = "정보를 가지고 오는데 실패했습니다."
                    onCompletion(nil,self.errorMessage)
                }
            }
        }
    }
    func myPageUpdate(onCompletion : @escaping (String?)->Void){
        let idToken = UserDefaults.standard.string(forKey: "idToken")!
        APIService.myPageUpdate(idToken: idToken) { statusCode in
            switch statusCode {
            case 200 :
                onCompletion(nil)
            case 401 :
                DispatchQueue.main.async {
                    APIService.updateFCMtoken(idToken: idToken) { checked in
                        self.errorMessage = checked ? "정보를 갱신중입니다. 다시 요청해주세요." : "정보를 가지고 오는데 실패했습니다."
                    }
                }
                onCompletion(self.errorMessage)
            case 406 :
                self.errorMessage = "미가입 회원입니다."
                SignupSingleton.shared.registerUserData(userDataType: .startPosition, variable: "onboard")
                //뷰에서 루트뷰 온보드로 변경
                onCompletion(self.errorMessage)
            default:
                self.errorMessage = "오류가 발생했습니다. 다시 시도하세요."
                onCompletion(self.errorMessage)
                break
            }
        }
    }
}
