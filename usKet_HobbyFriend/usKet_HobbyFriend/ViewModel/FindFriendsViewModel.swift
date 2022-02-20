//
//  FindFriendsViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/14.
//

import Foundation

final class FindFriendsViewModel {
    
    var errorMessage: String = ""
    var friends: Friends?
    
    func stopFindingFriend(onComletion: @escaping (String?) -> Void) {
        let idToken = Helper.shared.putIdToken()
        
        QueueAPI.stopFinding(idToken: idToken) { statusCode in
            switch statusCode {
            case 200:
                onComletion(nil)
            case 201:
                onComletion("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!")
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onComletion("정보 갱신중입니다.다시 시도해주세요!")
                }
            default:
                onComletion("오류가 발생했습니다. 다시 시도해주세요.")
            }
        }
    }
    
    func questSurround(onCompletion: @escaping (Friends?, Int?, String?) -> Void) {
        
        let idToken = Helper.shared.putIdToken()
        let location = Helper.shared.myLocation
        
        let parm = QuestSurroundParm(region: location.region, lat: location.lat, long: location.long)
        
        QueueAPI.questSurround(idToken: idToken, parm: parm) { friends, statusCode in
            switch statusCode {
            case 200:
                self.friends = friends
                onCompletion(friends, statusCode, nil)
            case 401:
                Helper.shared.getIdToken(refresh: true) { idToken in
                    guard idToken != nil else {
                        self.errorMessage = "토큰을 갱신중입니다."
                        onCompletion(nil, statusCode, self.errorMessage)
                        return
                    }
                    self.errorMessage = "토큰 갱신에 성공했습니다."
                    onCompletion(nil, statusCode, self.errorMessage)
                }
            default:
                self.errorMessage = "알 수없는 오류가 발생했습니다."
                onCompletion(nil, statusCode, self.errorMessage)
            }
        }
    }
    
    func checkUserMatch(onCompletion: @escaping (Int?, String?, Bool?) -> Void) {
        
        let idToken = Helper.shared.putIdToken()
        
        QueueAPI.userCheckMatch(idToken: idToken) { match, statusCode in

            switch statusCode {
            case 200 :
                guard let match = match else {
                    onCompletion(nil, "오류가 발생했어요.\n다시 시도해 주세요.", nil)
                    return
                }
                onCompletion(match.matched, match.matchedNick, nil)
            case 201 :
                onCompletion(nil, "오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다", true)
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion(nil, "토큰을 갱신을 갱신합니다.", nil)
                }
            default:
                onCompletion(nil, "알 수 없는 오류가 발생했어요", nil)
            }
        }
    }
}
