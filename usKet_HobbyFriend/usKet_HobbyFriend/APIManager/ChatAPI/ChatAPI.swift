//
//  ChatAPI.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/20.
//

import Moya

final class ChatAPI {
    
    static private let provider = MoyaProvider<ChatTarget>()
    
    static func sendChat(idToken: String, userUid: String, parm: SendChat, onCompletion : @escaping (Payload?, Int?) -> Void) {
        
        provider.request(.sendChat(idToken: idToken, userUid: userUid, parm)) { result in
            print("CHAT Send RESULT", result)
            switch result {
            case .success(let response):
                onCompletion(try? response.map(Payload.self), response.statusCode)
            case .failure(let error):
                onCompletion(nil, error.response?.statusCode)
            }
        }
    }
    
    static func fetchChat(idToken: String, userUid: String, lastchatDate: String, onCompletion: @escaping (Chat?, Int?) -> Void) {
        
        provider.request(.requestChatContent(idToken: idToken, from: userUid, lastchatDate: lastchatDate)) { result in
            print("CHAT Fetch RESULT", result)
            switch result {
            case .success(let response):
                onCompletion(try? response.map(Chat.self), response.statusCode)
            case .failure(let error):
                onCompletion(nil, error.response?.statusCode)
            }
        }
    }
}
