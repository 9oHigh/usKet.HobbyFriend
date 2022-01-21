//
//  CertificationViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import FirebaseAuth
import Foundation

class CertificationViewModel {
    
    lazy var toSignUp = LoginSingleTon()
    
    //전화번호, 인증번호, 닉네임, 이메일, 생년월일, 성별
    var validText : Observable<String> = Observable("")
    var validFlag : Observable<Bool> = Observable(false)
    var errorMessage : Observable<String> = Observable("")
    var error : String = ""
    
    // + Timer
    var timer : Observable<Int> = Observable(60)
    
    //MARK: Phone
    //전화번호 유효성
    func phoneValidate(phoneNumber : String){
        
        //정규식 활용
        let phoneRegex = "^01[0-1, 7][0-9]{7,8}$"
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
        
        result ? toSignUp.registerUserData(userDataType: .phoneNumber, variableType: String.self, variable: phone) : toSignUp.registerUserData(userDataType: .phoneNumber, variableType: String.self, variable: "None")
    }
    //휴대폰 인증문자 받기, 에러를 넘겨줄까 하다가 바인딩 시켜서 사용해보기로 함.
    func certificationPhone(onComplete : @escaping ()-> Void){
        
        //저장되어있는 번호 가지고오기
        let phoneNumber : String = UserDefaults.standard.string(forKey: "phoneNumber")!
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
    //Firebase Login
    func loginToFIR (onCompletion : @escaping (String?) -> Void) {
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!,
            verificationCode: self.validText.value
        )
        
        Auth.auth().signIn(with: credential) { authDataResult, error in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    
                    switch errCode {
                    case .invalidPhoneNumber :
                        self.errorMessage.value = "인증기간이 만료되었습니다."
                        onCompletion(nil)
                    case .invalidVerificationCode :
                        self.errorMessage.value = "인증번호가 일치하지 않아요."
                        onCompletion(nil)
                    case .invalidUserToken :
                        self.errorMessage.value = "에러 발생, 다시 시도하세요."
                        onCompletion(nil)
                    default :
                        self.errorMessage.value = "에러 발생, 다시 시도하세요."
                        onCompletion(nil)
                    }
                }
            }
            //성공시
            onCompletion("성공")
        }
    }
    //Firebase idToken
    func getIdToken(onCompletion : @escaping (Int) -> Void) {
        print(#function)
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            print("새싹에서 오래!")
            if error != nil {
                self.errorMessage.value = "오류 발생, 다시 시도해주세요."
                return
            }
            guard let idToken = idToken else { return }
            
            print("새싹가는중..0")
            //MARK: 서버로부터 사용자의 정보를 확인(get, /user)
            APIService.getUserData(token: idToken) { user, error in
                print("새싹가는중..1")
                //에러
                if let error = error {
                    switch error {
                    case .NotUser:
                        //이제부터 닉네임부터 시작!
                        print("역시 닉네임")
                        self.toSignUp.registerUserData(userDataType: .startPosition, variableType: String.self, variable: "nickName")
                        print("STATUS_CODEN",error.statusCode)
                        onCompletion(201)
                        return
                    default :
                        print("개사기")
                        self.errorMessage.value = "오류 발생, 다시 시도해주세요."
                    }
                }
                onCompletion(200)
            }
        }
    }
    
    //MARK: Nicname
    //닉네임 유효성
    func nickValidate(nickName : String){
        
        let validRegex = "^[가-힣A-Za-z0-9]{1,9}$"
        //정규식 매칭
        let testNumber = NSPredicate(format: "SELF MATCHES %@", validRegex)
        //반환
        let result = testNumber.evaluate(with: nickName)
        
        validFlag.value = result
    }
    
    //MARK: Birth
    //추가 변수 3개 ( 년, 월, 일 )
    var year : Observable<String> = Observable("")
    var month : Observable<String> = Observable("")
    var day : Observable<String> = Observable("")
    
    //생일 유효성
    func birthValidate(){
        //만 17세 이상인가
    }
    
    //MARK: Email
    //이메일 유효성
    func emailVlidate(){
        
    }
    
}
