//
//  Friends.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/07.
//

// MARK: - Friends
struct Friends: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}
