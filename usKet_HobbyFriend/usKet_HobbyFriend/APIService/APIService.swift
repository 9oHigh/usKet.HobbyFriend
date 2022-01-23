//
//  APIService.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import Foundation
import Alamofire

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
    
    static func signUpUser(idToken: String,completion: @escaping (Int?) -> Void) {
        
        let userDefault = UserDefaults.standard
        
        let headers = [
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"] as HTTPHeaders
        
        let parameters : Parameters = [
            //저장이 되어있는 상태기 때문에 강제해제 괜찮음
            "phoneNumber" : userDefault.string(forKey: "phoneNumber")!,
            "FCMtoken" : userDefault.string(forKey: "FCMtoken")!,
            "nick" : userDefault.string(forKey: "nick")!,
            "birth" : userDefault.string(forKey: "birth")!,
            "email" : userDefault.string(forKey: "email")!,
            //integer 값은 옵셔널 강제해제 필요없음
            "gender" : userDefault.integer(forKey: "gender")
        ]
        
        AF.request(Endpoint.toLogin.url.absoluteString,method: .post,parameters: parameters,headers: headers).responseString { response in
            //상태코드만 전달 -> 에러판별
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
    
    //    static func signup(username: String, email: String, password: String, completion: @escaping (User?, APIError?) -> Void) {
    //
    //        let url = Endpoint.signup.url
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.POST.rawValue
    //        request.httpBody = "username=\(username)&email=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //
    //    static func signin(identifier: String, password: String, completion: @escaping (User?, APIError?) -> Void) {
    //
    //        let url = Endpoint.signin.url
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.POST.rawValue
    //        request.httpBody = "identifier=\(identifier)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //    static func passwordChange(token: String,current: String, new: String,oneMore : String, completion: @escaping (User?, APIError?) -> Void) {
    //
    //        let url = Endpoint.changePWD.url
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.POST.rawValue
    //        request.httpBody = "currentPassword=\(current)&newPassword=\(new)&confirmNewPassword=\(new)".data(using: .utf8, allowLossyConversion: false)
    //        request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //    //포스트 하나 - 셀클릭시
    //    static func getPost(postId : String,token: String, completion: @escaping (PostElement?, APIError?) -> Void) {
    //
    //        let url = URL(string: "\(Endpoint.post.url)\(postId)")!
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.GET.rawValue
    //        request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //    //포스트 여러개 - 메인
    //    static func getPosts(token: String, completion: @escaping (Post?, APIError?) -> Void) {
    //
    //        let url = Endpoint.posts.url
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.GET.rawValue
    //        request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //    //답글들
    //    static func getComments(postId : String,token: String, completion: @escaping (Comments?, APIError?) -> Void) {
    //        let url = URL(string: "\(Endpoint.comments.url)\(postId)")!
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.GET.rawValue
    //        request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //    static func uploadComment(postId : String,comment: String,token: String, completion: @escaping (CommentElement?, APIError?) -> Void) {
    //
    //        let url = Endpoint.uploadComment.url
    //        var request = URLRequest(url: url)
    //
    //        request.httpMethod = HttpMethod.POST.rawValue
    //        request.httpBody = "comment=\(comment)&post=\(postId)".data(using: .utf8,allowLossyConversion: false)
    //        request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //
    //    static func deleteComment(commentId: Int,token: String, completion: @escaping (CommentElement?, APIError?) -> Void) {
    //        let url = URL(string: "\(Endpoint.uploadComment.url)/\(commentId)")!
    //        var request = URLRequest(url: url)
    //
    //        request.httpMethod = HttpMethod.DELETE.rawValue
    //
    //        request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //
    //    static func modifyComment( postId : String,commentId: Int,comment : String,token: String, completion: @escaping (CommentElement?, APIError?) -> Void) {
    //        let url = URL(string: "\(Endpoint.uploadComment.url)/\(commentId)")!
    //        print("\(url)")
    //        var request = URLRequest(url: url)
    //
    //        request.httpMethod = HttpMethod.PUT.rawValue
    //        request.httpBody = "comment=\(comment)&post=\(postId)".data(using: .utf8,allowLossyConversion: false)
    //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //        request.setValue("bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //
    //    static func uploadPost(token: String, text: String, completion: @escaping (PostElement?, APIError?) -> Void){
    //
    //        let url = Endpoint.uploadPost.url
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.POST.rawValue
    //        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
    //
    //        request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //
    //    static func modifyPost(postId : String,text : String,token: String, completion: @escaping (PostElement?, APIError?) -> Void){
    //
    //        let url = URL(string: "\(Endpoint.post.url)\(postId)")!
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.PUT.rawValue
    //        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
    //        request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
    //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //        URLSession.request(endpoint: request, completion: completion)
    //    }
    //    static func deletePost(postId : String,token: String, completion: @escaping (PostElement?, APIError?) -> Void){
    //
    //        let url = URL(string: "\(Endpoint.post.url)\(postId)")!
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HttpMethod.DELETE.rawValue
    //        request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
    //
    //        URLSession.request(endpoint: request, completion: completion)
    //}
}


