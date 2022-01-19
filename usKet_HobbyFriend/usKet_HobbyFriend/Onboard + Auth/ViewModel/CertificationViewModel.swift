//
//  CertificationViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import Foundation
import FirebaseAuth

class CerViewModel {
    
    var validText : Observable<String> = Observable("")
    
    var validFlag : Observable<Bool> = Observable(false)
    
    //Phone Number regex
    func checkValidation(){
        let regex = "^01[0-1, 7][0-9]{7,8}$"
    }
    
    //Certification Message Check
    func checkMessage(){
        
    }
}
