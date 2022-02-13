//
//  QueueParameters.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/07.
//

import Foundation

// MARK: - FindFriendParm
struct FindFriendParm: Codable {
    let type, region: Int
    let long, lat: Double
    let hf: [String]
}

// MARK: - QuestSurroundParm
struct QuestSurroundParm: Codable {
    let region: Int
    let lat, long: Double
}

// MARK: - RequestFriendParm
struct RequestFriendParm: Codable {
    let otheruid: String
}

// MARK: - AcceptFriendParm
struct AcceptFriendParm: Codable {
    let otheruid: String
}

// MARK: - Location
struct MyLocation {
    var region: Int
    var lat: Double
    var long: Double
}
