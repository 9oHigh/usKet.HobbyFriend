//
//  String + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import Foundation

extension String {
    
    //특정한 패턴에 맞추어 숫자를 입력 해주는 함수
    //정규식 포함
    func toPhoneNumberPattern(pattern: String, replacmentCharacter: Character) -> String {
        
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        
       pureNumber =  pureNumber.count > 11 ? String(pureNumber[...pureNumber.index(startIndex,offsetBy: 10)]) : pureNumber
        
        for index in 0 ..< pattern.count {
            
            guard index < pureNumber.count else { return pureNumber }

            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            
            guard patternCharacter != replacmentCharacter else { continue }
            
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        
        return pureNumber
    }
    
    func toCertiPattern(pattern: String, replacmentCharacter: Character) -> String {
        
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        
       pureNumber =  pureNumber.count > 6 ? String(pureNumber[...pureNumber.index(startIndex,offsetBy: 5)]) : pureNumber
        
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



