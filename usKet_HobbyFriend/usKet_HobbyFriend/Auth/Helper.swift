//
//  UserDefaults.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/21.
//

import UIKit
import Firebase

enum MatchStatus: String {
    case nothing
    case matching
    case matched
}

enum UserDataType: String {
    
    case phoneNumber
    case FCMtoken
    case nick
    case birth
    case email
    case gender
    case idToken
    case startPosition
    // MapView
    case startLocation
    // Matching status
    case isMatch
}

class Helper {
    
    // 싱글톤 - 유저디포트도 싱글톤이니까 싱싱글톤! 익스텐션으로 만들면 더 좋으려나
    static let shared = Helper()
    
    func registerUserData(userDataType: UserDataType, variable: String ) {    
        UserDefaults.standard.set(variable, forKey: userDataType.rawValue)
    }
    
    func userState() -> String {
        // 아직 저장된 값이 없다면
        guard let startPosition =  UserDefaults.standard.string(forKey: "startPosition") else {
            return "None"
        }
        // 저장되어 있다면
        return startPosition
    }
    
    // 회원탈퇴시 모든 값을 제거
    func userReset() {
        
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.removeObject(forKey: "nick")
        UserDefaults.standard.removeObject(forKey: "birth")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "gender")
        UserDefaults.standard.removeObject(forKey: "idToken")
        UserDefaults.standard.removeObject(forKey: "startPosition")
    }
    // 유저 디포트에 바로 저장해주자.
    func getIdToken(refresh: Bool, onCompletion : @escaping (String?) -> Void) {
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(refresh) { idToken, error in
            
            guard error == nil else {
                onCompletion(nil)
                return
            }
            guard let idToken = idToken else {
                return
            }
            Helper.shared.registerUserData(userDataType: .idToken, variable: idToken)
            onCompletion(idToken)
        }
        
    }

    // 유저디포트에서 가져다주자.
    func putIdToken() -> String {
        return UserDefaults.standard.string(forKey: "idToken")!
    }
    
}

// leftAligned
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
