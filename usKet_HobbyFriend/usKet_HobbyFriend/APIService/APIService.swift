////
////  APIService.swift
////  usKet_HobbyFriend
////
////  Created by 이경후 on 2022/01/19.
////
//
//import Foundation
//
//enum APIError : Error {
//    case failed
//    case noData
//    case invalidResponse
//    case invalidData
//    case badRequest     //400
//    case unAuthorized   //401
//    case notFound      //404
//    case timeout        //408
//}
//
//public class APIService {
//
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
//    }
//}
//
//
