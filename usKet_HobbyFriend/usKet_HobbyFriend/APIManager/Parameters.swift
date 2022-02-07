//
//  Parameters.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/05.
//

import Foundation

// 모델을 이용해 파라미터를 만드는 방법
// #호성쓰 참고#
struct SignupParameter: Encodable {
    
    var phoneNumber: String
    var FCMtoken: String
    var nick: String
    var birth: String
    var email: String
    var gender: Int
}

struct MypageParameter: Encodable {
    
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var gender: Int
    var hobby: String
}

struct FCMtokenParameter: Encodable {
    var FCMtoken: String
}

extension SignupParameter {
    
    var parameter: SignupParameter {
        
        let FCMtoken = UserDefaults.standard.string(forKey: "FCMtoken") ?? ""
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
        let nick = UserDefaults.standard.string(forKey: "nick") ?? ""
        let birth = UserDefaults.standard.string(forKey: "birth") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let gender = UserDefaults.standard.integer(forKey: "gender")
        
        return SignupParameter(phoneNumber: phoneNumber,
                               FCMtoken: FCMtoken,
                               nick: nick,
                               birth: birth,
                               email: email,
                               gender: gender)
    }
}

extension MypageParameter {
    
    var parameter: MypageParameter {
        
        let searchable = UserDefaults.standard.integer(forKey: "searchable")
        let ageMin = UserDefaults.standard.integer(forKey: "ageMin")
        let ageMax = UserDefaults.standard.integer(forKey: "ageMax")
        let gender = UserDefaults.standard.integer(forKey: "gender")
        let hobby = UserDefaults.standard.string(forKey: "hobby") ?? ""
        
        return MypageParameter(searchable: searchable,
                             ageMin: ageMin,
                             ageMax: ageMax,
                             gender: gender,
                             hobby: hobby)
    }
}

extension FCMtokenParameter {
    
    var toDomain: FCMtokenParameter {
        
          let FCMtoken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
          return FCMtokenParameter(FCMtoken: FCMtoken)
      }
}
