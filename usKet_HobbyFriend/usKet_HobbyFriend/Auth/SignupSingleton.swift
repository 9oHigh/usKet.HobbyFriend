//
//  UserDefaults.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/21.
//

import UIKit
import Firebase

enum UserDataType : String {
    
    case phoneNumber
    case FCMtoken
    case nick
    case birth
    case email
    case gender
    case idToken
    case startPosition
}

class SignupSingleton {
    
    //싱글톤 - 유저디포트도 싱글톤이니까 싱싱글톤! 익스텐션으로 만들면 더 좋으려나
    static let shared = SignupSingleton()
    
    //성별, 시작 포지션의 경우 Int값을 가지고 있으므로 -> 넘길 때 Int로 넘겨주자..
    func registerUserData(userDataType : UserDataType, variable : String ){
        
        UserDefaults.standard.set(variable, forKey: userDataType.rawValue)
    }
    
    func userState() -> String {
        //아직 저장된 값이 없다면
        guard let startPosition =  UserDefaults.standard.string(forKey: "startPosition") else {
            return "None"
        }
        //저장되어 있다면
        return startPosition
    }
    
    //회원탈퇴시 모든 값을 제거
    func userReset(){
        
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.removeObject(forKey: "FCMtoken")
        UserDefaults.standard.removeObject(forKey: "nick")
        UserDefaults.standard.removeObject(forKey: "birth")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "gender")
        UserDefaults.standard.removeObject(forKey: "idToken")
        UserDefaults.standard.removeObject(forKey: "startPosition")
    }
    //유저 디포트에 바로 저장해주자.
    func getIdToken(onCompletion : @escaping (String?)->Void) {
        
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            guard error == nil else {
                onCompletion(nil)
                return
            }
            guard let idToken = idToken else {
                return
            }
            SignupSingleton.shared.registerUserData(userDataType: .idToken, variable: "idToken")
            onCompletion(idToken)
        }
    }
    //유저디포트에서 가져다주자.
    func putIdToken() -> String {
        return UserDefaults.standard.string(forKey: "idToken")!
    }
}
