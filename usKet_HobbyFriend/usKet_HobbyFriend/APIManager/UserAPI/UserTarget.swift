//
//  UserAPI.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/05.
//

import Foundation
import Moya

// FCM 토큰 갱신, 유저정보확인은 회원가입 플로우, 상세정보등에서 가져가야하므로
// 만들어질 타겟에 대해 디폴트로 넣어주면 좋을 것 같음
private protocol DefaultTarget {
    // 반환을 자기 자신으로 해주어야 Enum에서 case로 분리 가능
    static func updateFCMToken(idToken: String, _ parameter: FCMtokenParameter) -> Self
    static func getUser(idToken: String) -> Self
}

enum UserTarget: DefaultTarget {
    
    case getUser(idToken: String)
    case signupUser(idToken: String, SignupParameter)
    case withdrawUser(idToken: String)
    case updateMypage(idToken: String, MypageParameter)
    case updateFCMToken(idToken: String, FCMtokenParameter)
}

// TargetType 프로토콜을 채택할 경우 다음과같이 프로퍼티들이 생성된다.
extension UserTarget: TargetType {

    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }

    var path: String {
        // 경로의 경우 기존의 타겟을 Switch문으로 해결하자
        switch self {

        case .getUser : return "user"
        case .signupUser : return "user"
        case .withdrawUser : return "user/withraw"
        case .updateMypage : return "user/update/mypage"
        case .updateFCMToken : return "user/update_fcm_token"
        }
    }

    var method: Moya.Method {
        // HTTP Method
        switch self {
        case .getUser: return .get
        case .signupUser: return .post
        case .withdrawUser: return .post
        case .updateMypage: return .post
        case .updateFCMToken: return .put
        }
    }

    var task: Task {
        switch self {

        case .getUser:
            return .requestPlain

        case .signupUser(_, let parameter):
            return .requestParameters(parameters: [
                "phoneNumber": parameter.phoneNumber,
                "FCMtoken": parameter.FCMtoken,
                "nick": parameter.nick,
                "birth": parameter.birth,
                "email": parameter.email,
                "gender": parameter.gender
            ], encoding: URLEncoding.default)

        case .withdrawUser:
            return .requestPlain

        case .updateMypage(_, let parameter):
            return .requestParameters(parameters: [
                "searchable": parameter.searchable,
                "ageMin": parameter.ageMin,
                "ageMax": parameter.ageMax,
                "gender": parameter.gender,
                "hobby": parameter.hobby
            ], encoding: URLEncoding.default)

        case .updateFCMToken(_, let parameter):
            return .requestParameters(parameters: [
                "FCMtoken": parameter.FCMtoken
            ], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {

        switch self {
        case .getUser(let idToken):
            return [
                "idtoken": idToken
            ]
        case .signupUser(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .withdrawUser(let idToken):
            return [
                "idtoken": idToken
            ]
        case .updateFCMToken(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .updateMypage(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }

    }
}
