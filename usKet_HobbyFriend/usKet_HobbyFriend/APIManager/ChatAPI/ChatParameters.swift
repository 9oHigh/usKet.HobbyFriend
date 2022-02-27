//
//  ChatParameters.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/20.
//

import Foundation

// MARK: - Chat
struct Chat: Codable {
    let payload: [Payload]
}

// MARK: - Payload
struct Payload: Codable {
    let id: String
    let v: Int
    let to: String
    let from: String
    let chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case from, to
        case chat
        case id = "_id"
        case createdAt
        case v = "__v"
    }
}

// MARK: - SendChat
struct SendChat: Codable {
    let chat: String
}
