//
//  EndPoint.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//


import Foundation

enum HttpMethod : String{
    
    case GET
    case POST
    case PUT
    case DELETE
}

enum Endpoint : String{
    
    case toLogin
    case toWithdraw
    case toRefreshFCM
}

extension Endpoint {
    
    var url: URL {
        switch self {
            
        case .toLogin:
            return .makeEndpoint("/user")
        case .toWithdraw :
            return .makeEndpoint("/user/withdraw")
        case .toRefreshFCM :
            return .makeEndpoint("/user/update_fcm_token")
        }
    }
}

extension URL {
    
    static let baseURL = "http://test.monocoding.com:35484"
    
    static func makeEndpoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}

extension URLSession {
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
    
//    //내부
//    static func request<T : Decodable>(_ session: URLSession = .shared,endpoint: URLRequest,completion : @escaping  (T?, APIError?) -> Void){
//        session.dataTask(endpoint) { data, response, error in
//            guard error == nil else {
//                completion(nil, .Failed)
//                return
//            }
//            
//            guard let data = data else {
//                completion(nil, .EmptyData)
//                return
//            }
//            
//            guard let response = response as? HTTPURLResponse else {
//                completion(nil, .InvalidResponse)
//                return
//            }
//            
//            //회원가입 성공 혹은 이미 가입한 유저라면 오류없이 진행
//            guard response.statusCode == 200 else {
//                //지속적으로 확인해보자
//                print("STATUS CODE : ",response.statusCode)
//                switch response.statusCode {
//                    case 201 : completion(nil, .NotUser)
//                    case 202 : completion(nil,.NicknameError)
//                    case 401: completion(nil,.UnAuthorized)
//                    case 408: completion(nil,.TimeOut)
//                    case 500: completion(nil,.ServerError)
//                    case 501 : completion(nil,.ClientError)
//                    default:
//                        completion(nil,.Failed)
//                }
//                
//                return
//            }
//       
//            do {
//                let decoder = JSONDecoder()
//                let decoded = try decoder.decode(T.self, from: data)
//                completion(decoded, nil)
//                
//            } catch {
//                //제발 이번에는 안뜨길
//                print("Decode Error")
//                completion(nil,.DecodeError)
//            }
//        }
//    }
}

