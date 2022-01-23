//
//  Date + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/22.
//

import Foundation

extension Date {
    
    func toStringEach() -> (String,String,String){
        
        let format = DateFormatter()
        
        format.dateFormat = "yyyy"
        let year = format.string(from: self)
        
        format.dateFormat = "M"
        let month = format.string(from: self)
        
        format.dateFormat = "d"
        let day = format.string(from: self)
        
        return (year,month,day)
    }
    
    func toOriginalString() -> String{
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let value = format.string(from: self)
        
        return value
    }
}
