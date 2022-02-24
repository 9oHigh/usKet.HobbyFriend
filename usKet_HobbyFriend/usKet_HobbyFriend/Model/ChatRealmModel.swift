//
//  ChatRealmModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/23.
//
import RealmSwift
import Realm

class Chatting: Object {
    @Persisted var name: String
    @Persisted var age: Int
}
class Person: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var name: String
    @Persisted var age: Int
    // Create relationships by pointing an Object field to another Class
    @Persisted var dogs: List<Chatting>
}

// MARK: - Chat
// struct Chat: Codable {
//    let payload: [Payload]
// }
//
// MARK: - Payload
// struct Payload: Codable {
//    let id: String
//    let v: Int
//    let to, from, chat, createdAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case v = "__v"
//        case to, from, chat, createdAt
//    }
// }
