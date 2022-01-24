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

class SignupSingleton {
    
    //싱글톤 - 유저디포트도 싱글톤이니까 싱싱글톤! 익스텐션으로 만들면 더 좋으려나
    static let shared = SignupSingleton()
    let userDefaults = UserDefaults.standard
    
    //성별, 시작 포지션의 경우 Int값을 가지고 있으므로 -> 넘길 때 Int로 넘겨주자..
    func registerUserData(userDataType : UserDataType, variable : String ){
        
            self.userDefaults.set(variable, forKey: userDataType.rawValue)
    }
    
    func userState() -> String {
        //아직 저장된 값이 없다면
        guard let startPosition =  self.userDefaults.string(forKey: "startPosition") else {
            return "None"
        }
        //저장되어 있다면
        return startPosition
    }
    
    //회원탈퇴시 모든 값을 제거
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
