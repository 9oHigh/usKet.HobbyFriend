//
//  FindFriendsViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/14.
//

import Foundation

final class FindFriendsViewModel {
    
    func stopFindingFriend(onComletion: @escaping (String?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: UserDataType.idToken.rawValue) ?? ""
        
        QueueAPI.stopFinding(idToken: idToken) { statusCode in
            switch statusCode {
            case 200:
                onComletion(nil)
            case 201:
                onComletion("누군가와 취미를 함께하기로 약속하셨어요!")
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onComletion("정보 갱신중입니다.다시 시도해주세요!")
                }
            default:
                onComletion("오류가 발생했습니다. 다시 시도해주세요.")
            }
        }
    }
}
