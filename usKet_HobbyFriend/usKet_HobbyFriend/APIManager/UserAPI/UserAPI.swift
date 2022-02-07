//
//  UserAPI.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/05.
//

import Moya

final class UserAPI {
    // 모야에서는 기존에 만들어둔 Target의 타입으로 만든다
    static private let provider = MoyaProvider<UserTarget>()
    
    static func getUser(idToken: String, onCompletion: @escaping (User?, Int?) -> Void) {
        
        provider.request(.getUser(idToken: idToken)) { result in
            switch result {
            case .success(let response):
                onCompletion(try? response.map(User.self), response.statusCode)
            case .failure(let error):
                onCompletion(nil, error.response?.statusCode)
            }
        }
        
    }
    
    static func signupUser(idToken: String, parameter: SignupParm, onCompletion: @escaping (Int?) -> Void) {
        
        provider.request(.signupUser(idToken: idToken, parameter)) { result in
            switch result {
            case .success(let response):
                onCompletion(response.statusCode)
            case.failure(let error):
                onCompletion(error.response?.statusCode)
            }
            
        }
    }
    
    static func withdrawUser(idToken: String, onCompletion: @escaping (Int?) -> Void) {
        
        provider.request(.withdrawUser(idToken: idToken)) { result in
                switch result {
                case .success(let response):
                    onCompletion(response.statusCode)
                case.failure(let error):
                    onCompletion(error.response?.statusCode)
                }
            }
    }
    
    static func updateFCMToken(idToken: String, parameter: FCMtokenParm, onCompletion: @escaping (Bool) -> Void) {
        
        provider.request(.updateFCMToken(idToken: idToken, parameter)) { result in
                switch result {
                case .success:
                    onCompletion(true)
                case .failure:
                    onCompletion(false)
                }
            }
    }
    
    static func updateMypage(idToken: String, parameter: MypageParm, onCompletion: @escaping (Int?) -> Void) {
        
        provider.request(.updateMypage(idToken: idToken, parameter)) { result in
                switch result {
                case .success(let response):
                    onCompletion(response.statusCode)
                case.failure(let error):
                    onCompletion(error.response?.statusCode)
                }
            }
    }
}
