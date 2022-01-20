//
//  CertificationViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import FirebaseAuth
import Foundation

class CertificationViewModel {
    
    //전화번호, 인증번호, 닉네임, 이메일, 생년월일, 성별
    var validText : Observable<String> = Observable("")
    var validFlag : Observable<Bool> = Observable(false)
    var errorMessage : Observable<String> = Observable("default")
    var error : String = ""
    
    // + Timer
    var timer : Observable<Int> = Observable(60)
    
    //MARK: Phone
    //전화번호 유효성
    func phoneValidate(phoneNumber : String){
        
        //정규식 활용
        let phoneRegex = "^01[0-1, 7][0-9]{8}$"
        //정규식 매칭
        let testNumber = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        //'-'제거하고 확인, 디버그시에 오류 따라서 초기값을 설정해주어야한다.
        let number = phoneNumber != "" ? phoneNumber.replacingOccurrences(of: "-", with: "") : "default"
        //반환
        let result = testNumber.evaluate(with: number)
        validFlag.value = result
        
        //UserDefault 저장
        let startIdx : String.Index = number.index(number.startIndex,offsetBy: 1)
        let phone = "+82" + number[startIdx...]
        result ? UserDefaults.standard.set(phone,forKey: "Phone") : UserDefaults.standard.set(phone,forKey: "Trash")
    }
    //휴대폰 인증문자 받기, 에러를 넘겨줄까 하다가 바인딩 시켜서 사용해보기로 함.
    func certificationPhone(onComplete : @escaping ()-> Void){
        
        //저장되어있는 번호 가지고오기
        let phoneNumber : String = UserDefaults.standard.string(forKey: "Phone")!
        //한국어설정
        Auth.auth().languageCode = "ko-KR"
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                //오류
                if let error = error {
                    print("Error :",error.localizedDescription)
                    self.errorMessage.value = "다시 시도해 주세요😢"
                    onComplete()
                    return
                }
                //성공
                self.errorMessage.value = ""
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                //성공한 케이스
                onComplete()
            }
    }
    
    //MARK: Certification
    //인증번호 유효성
    func cerValidate(validNumber : String){
        
        let validRegex = "^[0-9]{6}$"
        //정규식 매칭
        let testNumber = NSPredicate(format: "SELF MATCHES %@", validRegex)
        //반환
        let result = testNumber.evaluate(with: validNumber)
        
        validFlag.value = result
    }
    //타이머 함수
    func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
            if self.timer.value > 0 {
                self.timer.value -= 1
            } else {
                Timer.invalidate()
            }
        }
    }
    //Firebase idToken
    func getIdToken() {
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!,
            verificationCode: validText.value
        )
        //로그인을 해야 idToken을 받아 올 수 있음!
        Auth.auth().signIn(with: credential) { authResult, error in
            //에러가 있다면 바로 리턴
            if let error = error {
                
                print("AuthError(getIdToken): ",error.localizedDescription)
                self.errorMessage.value = "다시 시도해주세요"
                return

            } else {
                
                let currentUser = Auth.auth().currentUser
                
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print("AuthError(getIdTokenForcing): ",error)
                        self.errorMessage.value = "다시 시도해주세요"
                        return
                    }
                    // Send token to your backend via HTTPS
                    //MARK: 여기서 서버로부터 사용자의 정보를 확인(get, /user)
                }
            }
        }
    }
    
    //MARK: Nicname
    //닉네임 유효성
    func nickValidate(){
        
    }
    
    //MARK: Email
    //이메일 유효성
    func emailVlidate(){
        
    }
    
}
