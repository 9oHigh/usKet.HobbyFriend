//
//  ChatTarget.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/20.
//

import Moya

enum ChatTarget {
    
    case requestChatContent(idToken: String, from: String, lastchatDate: String)
    case sendChat(idToken: String, userUid: String, SendChat)
}

extension ChatTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .requestChatContent(_, let from, let lastchatDate):
            return "chat/\(from)?lastchatDate=\(lastchatDate)"
        case .sendChat(_, let userUid, _):
            return "chat/\(userUid)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestChatContent:
            return .get
        case .sendChat:
            return .post
        }
    }
    
    var task: Task {
        
        switch self {
        case .requestChatContent:
            return .requestPlain
            
        case .sendChat(_, _, let sendChat):
            return .requestParameters(parameters: [
                "chat": sendChat.chat
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestChatContent(let idToken, _, _):
            return [
                "idtoken": idToken
            ]
        case .sendChat(let idToken, _, _):
            return [
                "idtoken": idToken
            ]
        }
    }
}
