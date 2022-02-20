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
    var user: User?
    
    var myInfoMenu = BehaviorSubject<[MyInfo]>(value: [
        MyInfo(image: R.image.profileImg()!, name: UserDefaults.standard.string(forKey: "nick")!),
        MyInfo(image: R.image.notice()!, name: "공지사항"),
        MyInfo(image: R.image.qna()!, name: "자주 묻는 질문"),
        MyInfo(image: R.image.faq()!, name: "1:1 문의"),
        MyInfo(image: R.image.setting_alarm()!, name: "알림 설정"),
        MyInfo(image: R.image.permit()!, name: "이용 약관")
    ])
    // 너는 고정이라 필요없지만 일단 가져간다! 고쳐줄게!
    var myInfoTitle = BehaviorSubject<[MyTitle]>(value: [
        MyTitle(title: "좋은 매너"),
        MyTitle(title: "정확한 시간 약속"),
        MyTitle(title: "빠른 응답"),
        MyTitle(title: "친절한 성격"),
        MyTitle(title: "능숙한 취미 실력"),
        MyTitle(title: "유익한 시간")
    ])
    
    func resetUserInfo(onCompletion : @escaping (Bool, String?) -> Void) {
        
        let idToken = Helper.shared.putIdToken()
        
        UserAPI.withdrawUser(idToken: idToken) { statusCode in
            if statusCode == 200 {
                
                Helper.shared.userReset()
                Helper.shared.registerUserData(userDataType: .startPosition, variable: "onboard")
                onCompletion(true, nil)
            } else {
                self.errorMessage = "회원탈퇴에 실패했습니다."
                onCompletion(false, self.errorMessage)
            }
        }
    }
    
    func getUserInfo(onCompletion : @escaping (User?, String?) -> Void) {
        
        let idToken: String = Helper.shared.putIdToken()
        
        UserAPI.getUser(idToken: idToken) { user, statusCode in
            
            guard let statusCode = statusCode else {
                return
            }
            
            guard let user = user else {
                if statusCode == 401 {
                    Helper.shared.getIdToken(refresh: true) { newIdToken in
                        guard newIdToken != nil else {
                            self.errorMessage = "정보를 갱신중입니다. 다시 요청해주세요."
                            onCompletion(nil, self.errorMessage)
                            return
                        }
                        self.errorMessage = "정보를 가지고 오는데 실패했습니다."
                        onCompletion(nil, self.errorMessage)
                    }
                } else {
                    self.errorMessage = "정보를 가지고 오는데 실패했습니다."
                    onCompletion(nil, self.errorMessage)
                }
                return
            }
            switch statusCode {
            case 200:
                onCompletion(user, nil)
            case 401:
                Helper.shared.getIdToken(refresh: true) { newIdToken in
                    guard newIdToken != nil else {
                        self.errorMessage = "정보를 갱신중입니다. 다시 요청해주세요."
                        onCompletion(nil, self.errorMessage)
                        return
                    }
                    self.errorMessage = "정보를 가지고 오는데 실패했습니다."
                    onCompletion(nil, self.errorMessage)
                }
            case 406:
                self.errorMessage = "미가입 회원입니다."
                Helper.shared.registerUserData(userDataType: .startPosition, variable: "nickName")
                // 뷰에서 루트뷰 온보드로 변경
                onCompletion(nil, self.errorMessage)
            default :
                self.errorMessage = "정보를 가지고 오는데 실패했습니다."
                onCompletion(nil, self.errorMessage)
            }
        }
    }
    func myPageUpdate(onCompletion : @escaping (String?) -> Void) {
        
        let idToken: String = Helper.shared.putIdToken()
        let parameter = MypageParm(searchable: 0, ageMin: 0, ageMax: 0, gender: 0, hobby: "").parameter
        
        UserAPI.updateMypage(idToken: idToken, parameter: parameter) { statusCode in
            switch statusCode {
            case 200 :
                onCompletion(nil)
            case 401 :
                DispatchQueue.main.async {
                    Helper.shared.getIdToken(refresh: true) { newIdToken in
                        guard newIdToken != nil else {
                            self.errorMessage = "정보를 갱신중입니다. 다시 요청해주세요."
                            onCompletion(self.errorMessage)
                            return
                        }
                        self.errorMessage = "정보를 가지고 오는데 실패했습니다."
                        onCompletion(self.errorMessage)
                    }
                }
            case 406 :
                self.errorMessage = "미가입 회원입니다."
                Helper.shared.registerUserData(userDataType: .startPosition, variable: "nickName")
                // 뷰에서 루트뷰 온보드로 변경
                onCompletion(self.errorMessage)
            default:
                self.errorMessage = "오류가 발생했습니다. 다시 시도하세요."
                onCompletion(self.errorMessage)
            }
        }
    }
}
