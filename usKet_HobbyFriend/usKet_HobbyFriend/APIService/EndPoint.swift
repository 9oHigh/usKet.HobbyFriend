////
////  EndPoint.swift
////  usKet_HobbyFriend
////
////  Created by 이경후 on 2022/01/19.
////
//
//
//import Foundation
//
//enum HttpMethod : String{
//    case GET
//    case POST
//    case PUT
//    case DELETE
//}
//
//enum Endpoint {
//    case signup
//    case signin
//    case post
//    case posts
//    case comments
//    case changePWD
//    case uploadPost
//    case uploadComment
//}
//
//extension Endpoint {
//    var url: URL {
//
//        switch self {
//        case .signup: return .makeEndpoint("auth/local/register")
//        case .signin: return .makeEndpoint("auth/local")
//        case.changePWD : return .makeEndpoint("custom/change-password")
//        case .post:
//            return .makeEndpoint("posts/")
//        case .posts : return .makeEndpoint("posts?_sort=created_at:desc")
//        case .uploadPost: return .makeEndpoint("posts")
//        case .comments:
//            return .makeEndpoint("comments?post=")
//
//        case .uploadComment:
//            return .makeEndpoint("comments")
//        }
//    }
//}
//
//extension URL {
//
//    static let baseURL = "http://test.monocoding.com:1231/"
//
//    static func makeEndpoint(_ endpoint: String) -> URL {
//        URL(string: baseURL + endpoint)!
//    }
//}
//
//extension URLSession {
//
//    typealias Handler = (Data?, URLResponse?, Error? ) -> Void
//
//    //외부
//    @discardableResult //내부 반환 필요없음
//    func dataTask(_ endpoint: URLRequest, handler : @escaping Handler) -> URLSessionDataTask {
//        let tasks = dataTask(with: endpoint, completionHandler: handler)
//        tasks.resume()
//        return tasks
//    }
//
//    //내부
//    static func request<T : Decodable>(_ session: URLSession = .shared,endpoint: URLRequest,completion : @escaping  (T?, APIError?) -> Void){
//        session.dataTask(endpoint) { data, response, error in
//            guard error == nil else {
//                completion(nil, .failed)
//                return
//            }
//
//            guard let data = data else {
//                completion(nil, .noData)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else {
//                completion(nil, .invalidResponse)
//                return
//            }
//
//            guard response.statusCode == 200 else {
//                switch response.statusCode {
//                    case 400 : completion(nil,.badRequest)
//                    case 401: completion(nil,.unAuthorized)
//                    case 404: completion(nil,.notFound)
//                    case 408: completion(nil,.timeout)
//                    default:
//                    completion(nil,.failed)
//                }
//                print("오류 코드 안내 : ",response.statusCode)
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let decoded = try decoder.decode(T.self, from: data)
//                completion(decoded, nil)
//            } catch {
//                print("Decode Error")
//                completion(nil,.invalidData)
//            }
//
//        }
//    }
//}
//
