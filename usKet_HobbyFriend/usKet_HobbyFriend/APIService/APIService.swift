//
//  APIService.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import Foundation
import Alamofire
import Firebase

enum APIError : Error {
    
    case Failed
    case EmptyData
    case InvalidResponse
    case TimeOut
    case DecodeError
    case NotUser    // 201
    case NicknameError // 202
    case UnAuthorized //401 : Firebase Id Token
    case ServerError  //500
    case ClientError //501 : API에서 Header, Request Body 값 확인 ( 비어있는 값 존재 )
}

extension APIError {
    
    var statusCode : Int {
        
        switch self {
        case .NotUser :
            return 201
        case .NicknameError:
            return 202
        case .UnAuthorized:
            return 401
        case .ServerError :
            return 500
        case .ClientError:
            return 501
        default :
            return 501
        }
    }
}

public class APIService {
    
    static func getUser(idToken : String, completion: @escaping (User?,Int?) -> Void){
        let headers = ["idtoken" : idToken ] as HTTPHeaders
        
        AF.request(Endpoint.toLogin.url.absoluteString,method: .get, headers: headers).responseDecodable(of: User.self) { response in
            switch response.result {
                
            case .success:
                completion(response.value,response.response?.statusCode)
            case .failure:
                completion(nil,response.response?.statusCode)
            }
        }
    }
    
    static func signupUser(idToken: String,completion: @escaping (Int?) -> Void) {
        
        let userDefault = UserDefaults.standard
        
        let headers = [
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"] as HTTPHeaders
        
        let parameters : Parameters = [
            //저장이 되어있는 상태기 때문에 강제해제 괜찮지 않을까
            "phoneNumber" : userDefault.string(forKey: "phoneNumber")!,
            "FCMtoken" : userDefault.string(forKey: "FCMtoken")!,
            "nick" : userDefault.string(forKey: "nick")!,
            "birth" : userDefault.string(forKey: "birth")!,
            "email" : userDefault.string(forKey: "email")!,
            "gender" : userDefault.integer(forKey: "gender")
        ]
        
        AF.request(Endpoint.toLogin.url.absoluteString,method: .post,parameters: parameters,headers: headers).responseString { response in
            //상태코드만 전달 -> 에러판별
            //MARK: 여기서 바로 statusCode가 아니라 성공/ 실패로 나누어서 보내야 하나 고민고민
            completion(response.response?.statusCode)
        }
    }
    
    static func withdrawUser(idToken : String, completion : @escaping (Int?)->Void){
        
        let headers = [
            "idtoken" : idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ] as HTTPHeaders
        
        AF.request(Endpoint.toWithdraw.url.absoluteString,method: .post,headers: headers).responseString { response in
            completion(response.response?.statusCode)
        }
    }
    
    static func updateFCMtoken(idToken: String, completion : @escaping (Bool)->Void){
        
        let headers = [
            "idtoken" : idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ] as HTTPHeaders
        
        AF.request(Endpoint.toRefreshFCM.url.absoluteString,method: .put,headers: headers).responseString { response in
            switch response.result {
            case .success:
                Messaging.messaging().token { token, error in
                  if let error = error {
                    print("FCMToken ReFresh Error : ",error)
                  } else if let token = token {
                      SignupSingleton().registerUserData(userDataType: .FCMtoken, variable: token)
                  }
                }
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
