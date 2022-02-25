//
//  ChatViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/20.
//

import UIKit
import RxSwift

final class ChatViewModel {
    
    var otherNick: String?
    var otherUid: String?
    var chatList: [Payload] = []
    var colors: [Int] = [0, 0, 0, 0, 0, 0]
    var errorMessage: String = ""

    let reviewUser: [MyTitle] = [
        MyTitle(title: "좋은 매너"),
        MyTitle(title: "정확한 시간 약속"),
        MyTitle(title: "빠른 응답"),
        MyTitle(title: "친절한 성격"),
        MyTitle(title: "능숙한 취미 실력"),
        MyTitle(title: "유익한 시간")
    ]
    
    let reportUser: [MyTitle] = [
        MyTitle(title: "불법/사기"),
        MyTitle(title: "불편한 언행"),
        MyTitle(title: "노쇼"),
        MyTitle(title: "선정성"),
        MyTitle(title: "인신공격"),
        MyTitle(title: "기타")
    ]
    
    func userCheckIsMatch(onCompletion: @escaping (String?, Bool?) -> Void) {
        QueueAPI.userCheckMatch(idToken: Helper.shared.putIdToken()) { match, statusCode in
            
            switch statusCode {
            case 200 :
                guard let match = match else {
                    onCompletion("오류가 발생했어요.\n다시 시도해 주세요.", nil)
                    return
                }
                // 상대방 정보
                self.otherNick = match.matchedNick
                self.otherUid = match.matchedUid
                
                if match.dodged == 1 || match.reviewed == 1 {
                    Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.nothing.rawValue)
                    onCompletion("약속이 종료되어 채팅을 보낼 수 없습니다", true)
                    return
                }
                onCompletion(nil, nil)
            case 201 :
                Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.nothing.rawValue)
                onCompletion("오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다", true)
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("토큰", nil)
                }
            default:
                onCompletion("알 수 없는 오류가 발생했어요", nil)
            }
        }
    }
    
    func sendChat(userUid: String, chat: String, onCompletion: @escaping (String?) -> Void) {
        
        let idToken = Helper.shared.putIdToken()
        let parm: SendChat = SendChat(chat: chat)
        
        ChatAPI.sendChat(idToken: idToken, userUid: userUid, parm: parm) { chatting, statusCode in
            
            guard let chatting = chatting else {
                onCompletion("오류가 발생했습니다")
                return
            }
            
            // DB에 저장을 여기서 처리
            switch statusCode {
            case 200 :
                self.chatList.append(chatting)
                onCompletion(nil)
            case 201 :
                onCompletion("약속이 종료되어 채팅을 보낼 수 없습니다")
            case 401 :
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("토큰")
                    // 재시도
                }
            default:
                onCompletion("다시 시도해주세요")
            }
            
        }
    }
    
    func fetchChat(userUid: String, lastchatDate: String, onCompletion: @escaping (String?) -> Void) {
        
        let idToken = Helper.shared.putIdToken()
        
        ChatAPI.fetchChat(idToken: idToken, userUid: userUid, lastchatDate: lastchatDate) { chatData, statusCode in
            
            guard let chatData = chatData else {
                onCompletion("오류가 발생했습니다")
                return
            }

            // DB에 여기서 저장
            switch statusCode {
            case 200 :
                chatData.payload.forEach { data in
                    self.chatList.append(data)
                }
                onCompletion(nil)
            case 401 :
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("토큰")
                }
            default :
                onCompletion("오류가 발생했습니다")
            }
        }
    }
    
    func requestReport(parameter: Evaluation, onCompletion : @escaping (String?) -> Void ) {
        
        UserAPI.reportUser(idToken: Helper.shared.putIdToken(), parameter: parameter) { statusCode in
            
            switch statusCode {
            case 200:
                onCompletion(nil)
            case 201:
                onCompletion("이미 신고접수된 유저입니다")
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("다시 시도해주세요")
                }
            default:
                onCompletion("다시 시도해주세요")
            }
        }
    }
    
    func requestReview(parameter: Evaluation, onCompletion: @escaping (String?) -> Void) {
        QueueAPI.rateUser(idToken: Helper.shared.putIdToken(), parm: parameter, userId: parameter.otheruid) { statusCode in
            switch statusCode {
            case 200:
                onCompletion(nil) // to home
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("다시 시도해주세요")
                }
            default:
                onCompletion("다시 시도해주세요")
            }
        }
    }
    
    func dodgeMatch(otherUid: otherUid, onCompletion: @escaping (String?) -> Void) {
        QueueAPI.dodgeMatch(idToken: Helper.shared.putIdToken(), parm: otherUid) { statusCode in
            switch statusCode {
            case 200:
                onCompletion(nil)
            case 201:
                onCompletion("다시 시도해주세요")
            case 401:
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("다시 시도해주세요")
                }
            default:
                onCompletion("다시 시도해주세요")
            }
        }
    }
}
