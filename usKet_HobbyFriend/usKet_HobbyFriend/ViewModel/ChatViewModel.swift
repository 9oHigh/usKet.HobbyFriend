//
//  ChatViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/20.
//

final class ChatViewModel {
    
    var otherNick: String?
    
    func sendChat(userUid: String, chat: String, onCompletion: @escaping (String?) -> Void) {
        
        let idToken = Helper.shared.putIdToken()
        let parm: SendChat = SendChat(chat: chat)
        
        ChatAPI.sendChat(idToken: idToken, userUid: userUid, parm: parm) { chatting, statusCode in
            
            guard let chatting = chatting else {
                return
            }
            // DB에 저장을 여기서 처리
            switch statusCode {
            case 200 :
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
                return
            }
            // DB에 여기서 저장
            switch statusCode {
            case 200 :
                onCompletion(nil)
            case 401 :
                Helper.shared.getIdToken(refresh: true) { _ in
                    onCompletion("토큰")
                }
            default :
                onCompletion("다시 시도해주세요")
            }
            
        }
    }
}
