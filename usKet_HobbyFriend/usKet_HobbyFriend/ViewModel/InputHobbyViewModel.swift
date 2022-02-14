//
//  InputHobbyViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/11.
//

import RxSwift
import RxCocoa

enum Item: Int {
    case user = 0
    case recommend = 1
}

enum FindError: String {
    case report = "신고가 누적되어 이용하실 수 없습니다."
    case cancelPhase1 = "약속 취소 패널티로, 1분동안 이용하실 수 없습니다"
    case cancelPhase2 = "약속 취소 패널티로, 2분동안 이용하실 수 없습니다"
    case cancelPhase3 = "약속 취소 패널티로, 3분동안 이용하실 수 없습니다"
    case noneGender = "새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!"
    case noneIdToken = "잠시후 재시도 해주세요."
}

struct Hobby {
    var hobby: String
    var type: Item
}

final class InputHobbyViewModel {
  
    var friends: Friends?
    var wantItems: [String] = []
    var userItems: [Hobby] = []
    var searchItems: [String] = []
    
    var errorMessage: String = ""
    // 최초
    func getUserHobbies() {
        
        var hobbies: [String] = []
        
        self.friends!.fromRecommend.forEach { item in
                userItems.append(Hobby(hobby: item, type: .recommend))
        }
        
        self.friends!.fromQueueDB.forEach { items in
            items.hf.forEach { item in
                
                if hobbies.contains(item) {} else {
                    hobbies.append(item)
                    userItems.append(Hobby(hobby: item, type: .user))
                }
            }
        }
    }
    
    func findFriends(onCompletion: @escaping (String?, Bool?) -> Void) {
        
        let idToken = Helper.shared.putIdToken()
        let myLocation = Helper.shared.myLocation
        
        let parm = FindFriendParm(type: 2, region: myLocation.region, long: myLocation.long, lat: myLocation.lat, hf: wantItems)
        
        QueueAPI.findFriend(idToken: idToken, parm: parm) { statusCode in

            switch statusCode {
            case 200:
                onCompletion(nil, nil)
            case 201:
                onCompletion(FindError.report.rawValue, nil)
            case 203:
                onCompletion(FindError.cancelPhase1.rawValue, nil)
            case 204:
                onCompletion(FindError.cancelPhase2.rawValue, nil)
            case 205:
                onCompletion(FindError.cancelPhase3.rawValue, nil)
            case 206:
                onCompletion(FindError.noneGender.rawValue, true)
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion(FindError.noneIdToken.rawValue, nil)
                }
            default:
                self.errorMessage = "오류가 발생했어요.\n다시 시도해주세요."
                onCompletion(self.errorMessage, nil)
            }
            return
        }
    }
    
}

extension InputHobbyViewModel {
    
    var numberOfSections: Int {
        return  2
    }
}
