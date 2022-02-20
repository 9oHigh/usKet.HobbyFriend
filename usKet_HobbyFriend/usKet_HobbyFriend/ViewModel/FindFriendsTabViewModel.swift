//
//  FindFriendsTabViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/15.
//

final class FindFriendsTabViewModel {
    
    var errorMessage: String = ""
    var friends: [FromQueueDB] = []
    
    func requestFriend(parm: String, onCompletion: @escaping (String?, Bool?) -> Void) {
        
        let requestUid = RequestFriendParm(otheruid: parm)
        
        QueueAPI.requestFriend(idToken: Helper.shared.putIdToken(), parm: requestUid) { statusCode in

            switch statusCode {
            case 200 :
                onCompletion("취미 함께 하기 요청을 보냈습니다", false)
            case 201 :
                Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.matched.rawValue)
                onCompletion("상대방도 취미 함께 하기를 요청했습니다. 채팅방으로 이동합니다", true)
            case 202 :
                onCompletion("상대방이 취미 함께 하기를 그만두었습니다", false)
            case 401 :
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("토큰을 갱신중입니다.", false)
                }
            default:
                onCompletion("오류가 발생했습니다. 다시 시도해주세요.", false)
            }
        }
    }
    
    func acceptFriend(parm: String, onCompletion: @escaping (String?, Bool?) -> Void) {
        
        let acceptUid = AcceptFriendParm(otheruid: parm)
        
        QueueAPI.acceptFriend(idToken: Helper.shared.putIdToken(), parm: acceptUid) { statusCode in

            switch statusCode {
            case 200:
                Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.matched.rawValue)
                onCompletion("", true)
            case 201:
                onCompletion("상대방이 이미 다른 사람과 취미를 함께 하는 중입니다", false)
            case 202:
                onCompletion("상대방이 취미 함께 하기를 그만두었습니다", false)
            case 203:
                onCompletion("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!", false)
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("토큰을 갱신중입니다.", false)
                }
            default:
               onCompletion("오류가 발생했습니다. 다시 시도해주세요.", false)
            }
        }
    }
    
    func userCheckIsMatch(onCompletion: @escaping (Int?, String?, Bool?) -> Void) {
        QueueAPI.userCheckMatch(idToken: Helper.shared.putIdToken()) { match, statusCode in
            
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
