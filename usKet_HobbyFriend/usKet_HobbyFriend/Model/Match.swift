//
//  Match.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/07.
//

import Foundation

// MARK: - Match
struct Match: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
}
