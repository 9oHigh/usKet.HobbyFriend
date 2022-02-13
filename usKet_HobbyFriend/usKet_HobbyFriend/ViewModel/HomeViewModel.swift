//
//  HomeViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/08.
//
//

import UIKit

final class HomeViewModel {
    
    var errorMessage = ""
    
    func getUserInfo(onCompletion: @escaping (User?, Int?, String?) -> Void) {
        
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        
        UserAPI.getUser(idToken: idToken) { user, statusCode in
            switch statusCode {
            case 200:
                onCompletion(user, statusCode, nil)
            case 401:
                Helper.shared.getIdToken(refresh: true) { idToken in
                    guard idToken != nil else {
                        self.errorMessage = "토큰 갱신에 실패했어요. 다시 시도해주세요."
                        onCompletion(nil, statusCode, self.errorMessage)
                        return
                    }
                    self.errorMessage = "토큰 갱신에 성공했습니다. 다시 시도해주세요."
                    onCompletion(nil, statusCode, self.errorMessage)
                }
            default:
                self.errorMessage = "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
                onCompletion(nil, statusCode, self.errorMessage)
            }
        }
    }
    
    func questSurround(region: Int, lat: Double, long: Double, onCompletion: @escaping (Friends?, Int?, String?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        let parm = QuestSurroundParm(region: region, lat: lat, long: long)
        
        QueueAPI.questSurround(idToken: idToken, parm: parm) { friends, statusCode in
            
            switch statusCode {
            case 200:
                onCompletion(friends, statusCode, nil)
            case 401:
                Helper.shared.getIdToken(refresh: true) { idToken in
                    guard idToken != nil else {
                        self.errorMessage = "토큰 갱신에 실패했어요. 다시 시도해주세요."
                        onCompletion(nil, statusCode, self.errorMessage)
                        return
                    }
                    self.errorMessage = "토큰 갱신에 성공했습니다. 다시 시도해주세요."
                    onCompletion(nil, statusCode, self.errorMessage)
                }
            default:
                self.errorMessage = "알 수없는 오류가 발생했습니다."
                onCompletion(nil, statusCode, self.errorMessage)
            }
        }
    }
    
}
