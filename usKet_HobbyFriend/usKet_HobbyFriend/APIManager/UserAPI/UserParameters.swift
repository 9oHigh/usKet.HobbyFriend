//
//  Parameters.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/05.
//

import Foundation

// 모델을 이용해 파라미터를 만드는 방법
// #호성쓰 참고#
struct SignupParm: Encodable {
    
    var phoneNumber: String
    var FCMtoken: String
    var nick: String
    var birth: String
    var email: String
    var gender: Int
}

struct MypageParm: Encodable {
    
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var gender: Int
    var hobby: String
}

struct FCMtokenParm: Encodable {
    var FCMtoken: String
}

extension SignupParm {
    
    var parameter: SignupParm {
        
        let FCMtoken = UserDefaults.standard.string(forKey: "FCMtoken") ?? ""
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
        let nick = UserDefaults.standard.string(forKey: "nick") ?? ""
        let birth = UserDefaults.standard.string(forKey: "birth") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let gender = UserDefaults.standard.integer(forKey: "gender")
        
        return SignupParm(phoneNumber: phoneNumber,
                               FCMtoken: FCMtoken,
                               nick: nick,
                               birth: birth,
                               email: email,
                               gender: gender)
    }
}

extension MypageParm {
    
    var parameter: MypageParm {
        
        let searchable = UserDefaults.standard.integer(forKey: "searchable")
        let ageMin = UserDefaults.standard.integer(forKey: "ageMin")
        let ageMax = UserDefaults.standard.integer(forKey: "ageMax")
        let gender = UserDefaults.standard.integer(forKey: "gender")
        let hobby = UserDefaults.standard.string(forKey: "hobby") ?? ""
        
        return MypageParm(searchable: searchable,
                             ageMin: ageMin,
                             ageMax: ageMax,
                             gender: gender,
                             hobby: hobby)
    }
}

extension FCMtokenParm {
    
    var parameter: FCMtokenParm {
        
          let FCMtoken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
          return FCMtokenParm(FCMtoken: FCMtoken)
      }
}
