//
//  String + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import Foundation

extension String {
    
    func toPhoneNumberPattern(pattern: String, replacmentCharacter: Character) -> String {
        
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        
        for index in 0 ..< pattern.count {
            
            guard index < pureNumber.count else { return pureNumber }

            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            
            guard patternCharacter != replacmentCharacter else { continue }
            
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}



