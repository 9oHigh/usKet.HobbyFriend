//
//  UserDefaults.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/21.
//

import Foundation
import UIKit

enum UserDataType : String {
    
    case phoneNumber
    case FCMtoken
    case nick
    case birth
    case email
    case gender
    case startPosition
}

class LoginSingleTon {
    
    //싱글톤 - 유저디포트도 싱글톤이니까 싱싱글톤!
    static let shared = LoginSingleTon()
    let userDefaults = UserDefaults.standard
    
    //성별, 시작 포지션의 경우 Int값을 가지고 있으므로
    func registerUserData<T>(userDataType : UserDataType, variableType : T, variable : String ){
        
        if T.self == Int.self {
            self.userDefaults.set(Int(variable), forKey: userDataType.rawValue)
        } else {
            self.userDefaults.set(variable, forKey: userDataType.rawValue)
        }
    }
    
    func userState() -> String {
        //아직 저장된 값이 없다면
        guard let startPosition =  self.userDefaults.string(forKey: "startPosition") else {
            return "None"
        }
        //저장되어 있다면
        return startPosition
    }
    
    func userReset(){
        userDefaults.removeObject(forKey: "phoneNumber")
        userDefaults.removeObject(forKey: "FCMtoken")
        userDefaults.removeObject(forKey: "nick")
        userDefaults.removeObject(forKey: "birth")
        userDefaults.removeObject(forKey: "email")
        userDefaults.removeObject(forKey: "gender")
        userDefaults.removeObject(forKey: "startPosition")
    }

}
