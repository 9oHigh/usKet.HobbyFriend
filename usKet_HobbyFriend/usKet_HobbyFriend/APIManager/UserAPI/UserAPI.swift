//
//  UserAPI.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/05.
//

import Foundation
import RxSwift
import Moya

class UserAPI {
    //모야에서는 기존에 만들어둔 Target의 타입으로 만든다
    static private let provider = MoyaProvider<UserTarget>()
    static let disposeBag = DisposeBag()
    
    static func getUser(idToken: String, onCompletion: @escaping (User?,Int?) -> Void){
        
        provider.rx.request(.getUser(idToken: idToken))
            .subscribe{ result in
                switch result {
                case .success(let response):
                    onCompletion(try? response.map(User.self),response.statusCode)
                case .failure(let error):
                    onCompletion(nil,error.asAFError?.responseCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    static func signupUser(idToken: String,parameter : SignupParameter ,onCompletion: @escaping (Int?) -> Void){
        
        provider.rx.request(.signupUser(idToken: idToken, parameter))
            .subscribe{ result in
                onCompletion(result.statusCode)
            }
            .disposed(by: disposeBag)
    }
    
    static func withdrawUser(idToken: String, onCompletion: @escaping (Int?) -> Void) {
        
        provider.rx.request(.withdrawUser(idToken: idToken))
            .subscribe{ result in
                onCompletion(result.statusCode)
            }
            .disposed(by: disposeBag)
    }
    
    static func updateFCMToken(idToken: String, parameter: FCMtokenParameter, onCompletion: @escaping (Bool) -> Void) {
        
        provider.rx.request(.updateFCMToken(idToken: idToken, parameter))
            .subscribe { result in
                switch result {
                case .success:
                    onCompletion(true)
                case .failure:
                    onCompletion(false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    static func updateMypage(idToken: String, parameter: MypageParameter, onCompletion: @escaping (Int?) -> Void) {
        
        provider.rx.request(.updateMypage(idToken: idToken, parameter))
            .subscribe { result in
                onCompletion(result.statusCode)
            }
            .disposed(by: disposeBag)
    }
}
