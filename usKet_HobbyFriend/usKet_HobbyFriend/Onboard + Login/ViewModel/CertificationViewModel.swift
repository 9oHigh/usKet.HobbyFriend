//
//  CertificationViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import FirebaseAuth
import Foundation

class CertificationViewModel {
    
    private lazy var toSignUp = LoginSingleTon()
    
    //전화번호, 인증번호, 닉네임, 이메일, 생년월일, 성별
    var validText : Observable<String> = Observable("")
    var validFlag : Observable<Bool> = Observable(false)
    var errorMessage : Observable<String> = Observable("")
    
    //MARK: Phone
    //전화번호 유효성
    internal func phoneValidate(phoneNumber : String){
        
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
    internal func certificationPhone(onComplete : @escaping ()-> Void){
        
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
    // Timer 변수 추가
    var timer : Observable<Int> = Observable(60)
    
    //인증번호 유효성
    internal func cerValidate(validNumber : String){
        
        let validRegex = "^[0-9]{6}$"
        //정규식 매칭
        let testNumber = NSPredicate(format: "SELF MATCHES %@", validRegex)
        //반환
        let result = testNumber.evaluate(with: validNumber)
        
        validFlag.value = result
    }
    //타이머 함수
    public func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
            if self.timer.value > 0 {
                self.timer.value -= 1
            } else {
                Timer.invalidate()
            }
        }
    }
    //Firebase Login
    internal func loginToFIR (onCompletion : @escaping (String?) -> Void) {
        
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
    internal func getIdToken(onCompletion : @escaping (Int) -> Void) {
        
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if error != nil {
                self.errorMessage.value = "오류 발생, 다시 시도해주세요."
                return
            }
            guard let idToken = idToken else { return }
            
            //MARK: 서버로부터 사용자의 정보를 확인(get, /user)
            APIService.getUser(idToken: idToken) { user, statusCode in
                
                switch statusCode {
                case 201 :
                    self.toSignUp.registerUserData(userDataType: .startPosition, variableType: String.self, variable: "nickName")
                    onCompletion(201)
                    return
                case 401 :
                    self.errorMessage.value = "갱신중.. 잠시만 기다려주세요"
                    DispatchQueue.main.async {
                        APIService.updateFCMtoken(idToken: idToken) { statusCode in
                            if statusCode == 200 {
                                self.errorMessage.value = "갱신이 완료되었습니다. 다시 시도하세요"
                            } else {
                                self.errorMessage.value = "갱신에 실패했습니다. 다시 시도하세요"
                            }
                        }
                    }
                default :
                    self.errorMessage.value = "오류 발생, 다시 시도해주세요"
                }
                onCompletion(200)
            }
        }
    }
    
    //MARK: Nicname
    //닉네임 유효성
    internal func nickValidate(nickName : String){
        
        let validRegex = "^[가-힣A-Za-z0-9]{1,9}$"
        //정규식 매칭
        let testName = NSPredicate(format: "SELF MATCHES %@", validRegex)
        //반환
        let result = testName.evaluate(with: nickName)
        
        self.toSignUp.registerUserData(userDataType: .nick, variableType: String.self, variable: validText.value)
        
        validFlag.value = result
    }
    
    //MARK: Birth
    //추가 변수 3개 ( 년, 월, 일 )
    var prevDate : Observable<(String,String,String)> = Observable((Date().toStringEach().0,Date().toStringEach().1,Date().toStringEach().2))
    var birthDate : Observable<(String,String,String)> = Observable(("","",""))
    
    //생일 유효성
    internal func birthValidate(){
        
        let today = Date().toStringEach() // 오늘을 기준
        let age : Int = abs(Int(birthDate.value.0)! - Int(today.0)!)
        
        if westernAge(age: age, birthMonth: Int(birthDate.value.1)!, birthDay: Int(birthDate.value.2)!) {
            
            self.errorMessage.value = ""
            toSignUp.registerUserData(userDataType: .birth, variableType: String.self, variable: self.validText.value)
        } else {
            self.errorMessage.value = "만 17세 이상만 가입가능합니다."
        }
    }
    //만나이 계산
    public func westernAge(age: Int, birthMonth: Int,birthDay: Int) -> Bool{
        
        // 만 17세 이상
        if age >= 18 { return true }
        // 만 17세 미만
        else if age < 17 { return false }
        // 검사요망 ( 17세 )
        else {
            //오늘 날짜를 기준
            let today = Date().toStringEach()
            // 오늘의 달보다 생일 달이 작으면 무조건 17세 미만
            if birthMonth > Int(today.1)! {
                return false
                //같으면 일까지 검사
            } else if birthMonth == Int(today.1)!{
                return  birthDay <= Int(today.2)! ? true : false
                //크다면 만 17세 이상
            } else {
                return true
            }
        }
    }
    //모든 값이 변환되었나
    public func checkFullDate() -> Bool{
        if birthDate.value.0 != "" && birthDate.value.1 != "" &&  birthDate.value.2 != ""{
            validFlag.value = true
            self.errorMessage.value = ""
            return true
        } else {
            validFlag.value = false
            self.errorMessage.value = "년/월/일 모두 선택해주세요"
            return false
        }
    }
    //MARK: Email
    //이메일 유효성
    internal func emailValidate(email : String){
        
        let validRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        //정규식 매칭
        let testEmail = NSPredicate(format: "SELF MATCHES %@", validRegex)
        //반환
        let result = testEmail.evaluate(with: email)
        
        self.errorMessage.value = result ?
        "" : "형식이 옳바르지 않습니다"
        
        toSignUp.registerUserData(userDataType: .email, variableType: String.self, variable: email)
        
        validFlag.value = result
        
    }
    //MARK: Gender
    //값가지고오깅
    internal func genderValidate(){
        
        if validText.value != "" && validText.value != "2"{
            toSignUp.registerUserData(userDataType: .gender, variableType: Int.self, variable: validText.value)
            validFlag.value = true
        } else {
            toSignUp.registerUserData(userDataType: .gender, variableType: Int.self, variable: validText.value)
            validFlag.value = false
        }
    }
    
    //MARK: Signup
    internal func signupToSeSAC(onCompletion : @escaping (Int)->Void ){
        
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            guard let idToken = idToken else {
                self.errorMessage.value = "오류 발생, 잠시후 다시 시도해주세요"
                return
            }
            
            APIService.signUpUser(idToken: idToken) { statusCode in
                print("IN SIGNUP : ",statusCode!)
                switch statusCode {
                case 200 :
                    onCompletion(200)
                    self.toSignUp.registerUserData(userDataType: .startPosition, variableType: String.self, variable: "home")
                case 201 :
                    self.toSignUp.registerUserData(userDataType: .startPosition, variableType: String.self, variable: "home")
                    self.errorMessage.value = "이미 가입이 완료되었습니다"
                    onCompletion(statusCode!)
                    return
                case 202 :
                    self.toSignUp.registerUserData(userDataType: .startPosition, variableType: String.self, variable: "nickName")
                    self.errorMessage.value = "사용할 수 없는 닉네임입니다"
                    onCompletion(statusCode!)
                    return
                case 401 :
                    self.errorMessage.value = "갱신중.. 잠시만 기다려주세요"
                    DispatchQueue.main.async {
                        APIService.updateFCMtoken(idToken: idToken) { statusCode in
                            if statusCode == 200 {
                                self.errorMessage.value = "갱신이 완료되었습니다. 다시 시도하세요"
                            } else {
                                self.errorMessage.value = "갱신에 실패했습니다. 다시 시도하세요"
                            }
                        }
                    }
                    onCompletion(statusCode!)
                    return
                default :
                    self.errorMessage.value = "오류 발생, 잠시후 다시 시도해주세요"
                    onCompletion(statusCode!)
                    return
                }
            }
        }
    }
    func refreshFCMtoken(){
        
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            guard let idToken = idToken else {
                self.errorMessage.value = "오류 발생, 잠시후 다시 시도해주세요"
                return
            }
            
            APIService.signUpUser(idToken: idToken) { statusCode in
                print("IN SIGNUP : ",statusCode!)
                switch statusCode {
                case 201 :
                    self.errorMessage.value = "이미 가입이 완료되었습니다"
                   
                case 202 :
                    self.errorMessage.value = "사용할 수 없는 닉네임입니다"
                   
                case 401 :
                    self.errorMessage.value = "갱신중.. 잠시만 기다려주세요"
                    DispatchQueue.main.async {
                        APIService.updateFCMtoken(idToken: idToken) { statusCode in
                            if statusCode == 200 {
                                self.errorMessage.value = "갱신이 완료되었습니다. 다시 시도하세요"
                                print("갱신완료!")
                            } else {
                                self.errorMessage.value = "갱신에 실패했습니다. 다시 시도하세요"
                                print("갱신실패!")
                            }
                        }
                    }
                   
                default :
                    self.errorMessage.value = "오류 발생, 잠시후 다시 시도해주세요"
                   
                }
                
            }
        }
    }

}

