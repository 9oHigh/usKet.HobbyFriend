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
