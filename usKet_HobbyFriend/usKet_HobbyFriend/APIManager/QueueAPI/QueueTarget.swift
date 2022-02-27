//
//  QueueTarget.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/07.
//

import Moya

enum QueueTarget {
    
    case findFriend(idToken: String, FindFriendParm)
    case stopFinding(idToken: String)
    case questSurround(idToken: String, QuestSurroundParm)
    case requestFriend(idToken: String, RequestFriendParm)
    case acceptFriend(idToken: String, AcceptFriendParm)
    case userCheckMatch(idToken: String)
    case rateUser(idToken: String, Evaluation, userId: String)
    case dodgeMatching(idToken: String, otherUid)
}

extension QueueTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .findFriend:
            return "queue"
        case .stopFinding:
            return "queue"
        case .questSurround:
            return "queue/onqueue"
        case .requestFriend:
            return "queue/hobbyrequest"
        case .acceptFriend:
            return "queue/hobbyaccept"
        case .userCheckMatch:
            return "queue/myQueueState"
        case .rateUser(_, _, let userId):
            return "queue/rate/\(userId)"
        case .dodgeMatching:
            return "queue/dodge"
        }
    }
    
    var method: Method {
        switch self {
        case .findFriend:
            return .post
        case .stopFinding:
            return .delete
        case .questSurround:
            return .post
        case .requestFriend:
            return .post
        case .acceptFriend:
            return .post
        case .userCheckMatch:
            return .get
        case .rateUser:
            return .post
        case .dodgeMatching:
            return .post
        }
    }
    
    var task: Task {
        switch self {
            
        case .findFriend(_, let parm):
            return .requestParameters(parameters: [
                "type": parm.type,
                "region": parm.region,
                "long": parm.long,
                "lat": parm.lat,
                "hf": parm.hf
            ], encoding: URLEncoding(arrayEncoding: .noBrackets))
            
        case .stopFinding:
            return .requestPlain
            
        case .questSurround(_, let parm):
            return .requestParameters(parameters: [
                "region": parm.region,
                "lat": parm.lat,
                "long": parm.long
            ], encoding: URLEncoding.default)
            
        case .requestFriend(_, let parm):
            return .requestParameters(parameters: [
                "otheruid": parm.otheruid
            ], encoding: URLEncoding.default)
            
        case .acceptFriend(_, let parm):
            return .requestParameters(parameters: [
               "otheruid": parm.otheruid
            ], encoding: URLEncoding.default)
            
        case .userCheckMatch:
            return .requestPlain
            
        case .rateUser(_, let parm, _):
            return .requestParameters(parameters: [
                "otheruid": parm.otheruid,
                "reputation": parm.reputation,
                "comment": parm.comment
            ], encoding: URLEncoding(arrayEncoding: .noBrackets))
            
        case .dodgeMatching(_, let parm):
            return .requestParameters(parameters: [
               "otheruid": parm.otheruid
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .findFriend(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .stopFinding(let idToken):
            return [
                "idtoken": idToken
            ]
        case .questSurround(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .requestFriend(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .acceptFriend(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .userCheckMatch(let idToken):
            return [
                "idtoken": idToken
            ]
        case .rateUser(idToken: let idToken, _, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .dodgeMatching(idToken: let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
        
}
