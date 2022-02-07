//
//  CertificationViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import FirebaseAuth

// 2022.02.05
// MARK: StatusCode가 아닌 모듈화 필요 INT값을 그대로 가져가는건 굉장히 안좋아보임.

class CertificationViewModel {
    
    // 전화번호, 인증번호, 닉네임, 이메일, 생년월일, 성별
    var validText: Observable<String> = Observable("")
    var validFlag: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String> = Observable("")
    
    // MARK: Phone
    // 전화번호 유효성
    func phoneValidate() {
        
        // 정규식 활용
        let phoneRegex = "^01[0-1, 7][0-9]{7,8}$"
        let testNumber = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        // '-'제거하고 확인, 디버그시에 오류.. 따라서 초기값을 설정해주어야한다.
        let number = validText.value != "" ? validText.value.replacingOccurrences(of: "-", with: "") : "DEFAULT"
        
        // 반환
        let result = testNumber.evaluate(with: number)
        validFlag.value = result
        
        // UserDefault 저장
        let startIdx: String.Index = number.index(number.startIndex, offsetBy: 1)
        let phone = "+82" + number[startIdx...]
        
        result ? SignupSingleton.shared.registerUserData(userDataType: .phoneNumber, variable: phone) : SignupSingleton.shared.registerUserData(userDataType: .phoneNumber, variable: "None")
    }
    
    // 휴대폰 인증문자 받기, 바인딩 시켜서 사용해보기로 함.
    func certificationPhone(onCompletion : @escaping () -> Void) {
        
        // 저장되어있는 번호 가지고오기
        let phoneNumber: String = UserDefaults.standard.string(forKey: "phoneNumber")!
        
        // 한국어설정
        Auth.auth().languageCode = "ko-KR" // 되는거 맞아!?
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                // 오류
                guard error == nil else {
                    self.errorMessage.value = "오류발생, 다시 시도해 주세요"
                    onCompletion()
                    return
                }
                // 성공
                self.errorMessage.value = ""
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                // 성공한 케이스
                onCompletion()
            }
    }
    
    // MARK: Certification
    // Timer 변수 추가
    var timer: Observable<Int> = Observable(60)
    
    // 인증번호 유효성
    func cerValidate() {
        
        let validRegex = "^[0-9]{6}$"
        // 정규식 매칭
        let testNumber = NSPredicate(format: "SELF MATCHES %@", validRegex)
        // 반환
        let result = testNumber.evaluate(with: validText.value)
        
        validFlag.value = result
    }
    
    // 타이머 함수
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { time in
            
            if self.timer.value > 0 {
                
                self.timer.value -= 1
                
            } else {
                
                time.invalidate()
            }
        }
    }
    
    // Firebase Login
    func loginToFIR (onCompletion : @escaping (String?) -> Void) {
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!,
            verificationCode: self.validText.value
        )
        
        Auth.auth().signIn(with: credential) { _, error in
            
            if let error = error {
                
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    
                    switch errCode {
                    case .invalidPhoneNumber :
                        self.errorMessage.value = "인증기간이 만료되었습니다."
                        onCompletion(nil)
                        return
                    case .invalidVerificationCode :
                        self.errorMessage.value = "인증번호가 일치하지 않아요."
                        onCompletion(nil)
                        return
                    case .invalidUserToken :
                        self.errorMessage.value = "에러 발생, 다시 시도하세요."
                        onCompletion(nil)
                        return
                    case .tooManyRequests :
                        self.errorMessage.value = "과도한 인증시도가 있습니다. 다시 시도하세요."
                        onCompletion(nil)
                        return
                    default :
                        self.errorMessage.value = "에러 발생, 다시 시도하세요."
                        onCompletion(nil)
                        return
                    }
                }
            }
            // 성공시
            self.errorMessage.value = ""
            onCompletion("SUCCESS")
        }
    }
    
    // Firebase idToken
    func getIdToken(onCompletion : @escaping (Int) -> Void) {
        
        SignupSingleton.shared.getIdToken { idToken in
            
            guard let idToken = idToken else {
                self.errorMessage.value = "오류 발생, 다시 시도해주세요."
                return
            }
            
            UserAPI.getUser(idToken: idToken) { user, statusCode in
                
                guard let user = user else {
                    switch statusCode {
                    case 401 :
                        DispatchQueue.main.async {
                            SignupSingleton.shared.getIdToken { newIdToken in
                                guard let newIdToken = newIdToken else {
                                    self.errorMessage.value = "토큰 갱신에 실패했습니다. 다시 시도하세요"
                                    onCompletion(401)
                                    return
                                }
                                SignupSingleton.shared.registerUserData(userDataType: .idToken, variable: newIdToken)
                                self.errorMessage.value = "토큰 갱신이 완료되었습니다. 다시 시도하세요"
                                onCompletion(401)
                            }
                        }
                        return
                    case 406 :
                        SignupSingleton.shared.registerUserData(userDataType: .startPosition, variable: "nickName")
                        onCompletion(406)
                        return
                    default :
                        self.errorMessage.value = "오류 발생, 다시 시도해주세요"
                    }
                    return
                }
                
                SignupSingleton.shared.registerUserData(userDataType: .startPosition, variable: "home")
                SignupSingleton.shared.registerUserData(userDataType: .nick, variable: user.nick) // userdefault를 이용해서..
                onCompletion(200)
            }
        }
    }
    
    // MARK: Nicname
    // 닉네임 유효성
    func nickValidate() {
        
        // 정규식 매칭
        let validRegex = "^[가-힣A-Za-z0-9]{1,9}$"
        let testName = NSPredicate(format: "SELF MATCHES %@", validRegex)
        
        // 반환
        let result = testName.evaluate(with: validText.value)
        
        validFlag.value = result
        self.errorMessage.value = result ? "" : "1자이상 10자이내로 입력해주세요"
        result ? SignupSingleton.shared.registerUserData(userDataType: .nick, variable: validText.value) : ()
    }
    
    // MARK: Birth
    // 추가 변수 3개 ( 년, 월, 일 )
    var prevDate: Observable<(String, String, String)> = Observable((Date().toStringEach().0, Date().toStringEach().1, Date().toStringEach().2))
    var birthDate: Observable<(String, String, String)> = Observable(("", "", ""))
    
    // 생일 유효성
    func birthValidate() {
        
        let today = Date().toStringEach() // 오늘을 기준
        let age: Int = abs(Int(birthDate.value.0)! - Int(today.0)!)
        
        if westernAge(age: age, birthMonth: Int(birthDate.value.1)!, birthDay: Int(birthDate.value.2)!) {
            
            self.errorMessage.value = ""
            SignupSingleton.shared.registerUserData(userDataType: .birth, variable: self.validText.value)
        } else {
            
            self.errorMessage.value = "만 17세 이상만 가입가능합니다."
        }
    }
    
    // 만나이 계산 : 생각해보니까 Calendar 쓰면 되지 않나.. 외국애들 기준으로 만들었으니까 나이도 그렇게 책정이 될텐데
    public func westernAge(age: Int, birthMonth: Int, birthDay: Int) -> Bool {
        
        // 만 17세 이상
        if age >= 18 { return true }
        // 만 17세 미만
        else if age < 17 { return false }
        // 검사요망 ( 17세 )
        else {
            // 오늘 날짜를 기준
            let today = Date().toStringEach()
            // 오늘의 달보다 생일 달이 작으면 무조건 17세 미만
            if birthMonth > Int(today.1)! {
                return false
                // 같으면 일까지 검사
            } else if birthMonth == Int(today.1)! {
                return  birthDay <= Int(today.2)! ? true : false
                // 크다면 만 17세 이상
            } else {
                return true
            }
        }
    }
    
    // 모든 값이 변환되었나
    func checkFullDate() -> Bool {
        
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
    
    // MARK: Email
    // 이메일 유효성
    func emailValidate() {
        
        let validRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        // 정규식 매칭
        let testEmail = NSPredicate(format: "SELF MATCHES %@", validRegex)
        // 반환
        let result = testEmail.evaluate(with: validText.value)
        validFlag.value = result
        
        self.errorMessage.value = result ? "" : "형식이 옳바르지 않습니다"
        SignupSingleton.shared.registerUserData(userDataType: .email, variable: validText.value)
    }
    
    // MARK: Gender
    
    func genderValidate() {
        
        if validText.value != "" && validText.value != "-1"{
            SignupSingleton.shared.registerUserData(userDataType: .gender, variable: validText.value)
            validFlag.value = true
        } else {
            SignupSingleton.shared.registerUserData(userDataType: .gender, variable: validText.value)
            validFlag.value = false
        }
    }
    
    // MARK: Signup
    func signupToSeSAC(onCompletion : @escaping (Int) -> Void ) {
        
        let idToken = SignupSingleton.shared.putIdToken()
        let parameter = SignupParameter(phoneNumber: "", FCMtoken: "", nick: "", birth: "", email: "", gender: 0).parameter
        
        UserAPI.signupUser(idToken: idToken, parameter: parameter) { statusCode in
            switch statusCode {
            case 200 :
                SignupSingleton.shared.registerUserData(userDataType: .startPosition, variable: "home")
                onCompletion(statusCode!)
                return
            case 201 :
                SignupSingleton.shared.registerUserData(userDataType: .startPosition, variable: "home")
                self.errorMessage.value = "이미 가입이 완료되었습니다"
                onCompletion(statusCode!)
                return
            case 202 :
                SignupSingleton.shared.registerUserData(userDataType: .startPosition, variable: "nickName")
                self.errorMessage.value = "사용할 수 없는 닉네임입니다"
                onCompletion(statusCode!)
                return
            case 401 :
                DispatchQueue.main.async {
                    SignupSingleton.shared.getIdToken { newIdToken in
                        guard newIdToken != nil else {
                            self.errorMessage.value = "갱신에 실패했습니다. 다시 시도하세요"
                            onCompletion(401)
                            return
                        }
                        self.errorMessage.value = "토큰이 갱시되었습니다. 다시 시도해주세요"
                        onCompletion(401)
                    }
                }
                return
            default :
                self.errorMessage.value = "오류 발생, 잠시후 다시 시도해주세요"
                onCompletion(statusCode!)
                return
            }
        }
    }
}
