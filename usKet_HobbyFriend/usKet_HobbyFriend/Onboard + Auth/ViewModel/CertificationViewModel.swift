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
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            if let errCode = AuthErrorCode(rawValue: error!._code) {

                switch errCode {
                  
                case .invalidCustomToken:
                    <#code#>
                case .customTokenMismatch:
                    <#code#>
                case .invalidCredential:
                    <#code#>
                case .userDisabled:
                    <#code#>
                case .operationNotAllowed:
                    <#code#>
                case .emailAlreadyInUse:
                    <#code#>
                case .invalidEmail:
                    <#code#>
                case .wrongPassword:
                    <#code#>
                case .tooManyRequests:
                    <#code#>
                case .userNotFound:
                    <#code#>
                case .accountExistsWithDifferentCredential:
                    <#code#>
                case .requiresRecentLogin:
                    <#code#>
                case .providerAlreadyLinked:
                    <#code#>
                case .noSuchProvider:
                    <#code#>
                case .invalidUserToken:
                    <#code#>
                case .networkError:
                    <#code#>
                case .userTokenExpired:
                    <#code#>
                case .invalidAPIKey:
                    <#code#>
                case .userMismatch:
                    <#code#>
                case .credentialAlreadyInUse:
                    <#code#>
                case .weakPassword:
                    <#code#>
                case .appNotAuthorized:
                    <#code#>
                case .expiredActionCode:
                    <#code#>
                case .invalidActionCode:
                    <#code#>
                case .invalidMessagePayload:
                    <#code#>
                case .invalidSender:
                    <#code#>
                case .invalidRecipientEmail:
                    <#code#>
                case .missingEmail:
                    <#code#>
                case .missingIosBundleID:
                    <#code#>
                case .missingAndroidPackageName:
                    <#code#>
                case .unauthorizedDomain:
                    <#code#>
                case .invalidContinueURI:
                    <#code#>
                case .missingContinueURI:
                    <#code#>
                case .missingPhoneNumber:
                    <#code#>
                case .invalidPhoneNumber:
                    <#code#>
                case .missingVerificationCode:
                    <#code#>
                case .invalidVerificationCode:
                    <#code#>
                case .missingVerificationID:
                    <#code#>
                case .invalidVerificationID:
                    <#code#>
                case .missingAppCredential:
                    <#code#>
                case .invalidAppCredential:
                    <#code#>
                case .sessionExpired:
                    <#code#>
                case .quotaExceeded:
                    <#code#>
                case .missingAppToken:
                    <#code#>
                case .notificationNotForwarded:
                    <#code#>
                case .appNotVerified:
                    <#code#>
                case .captchaCheckFailed:
                    <#code#>
                case .webContextAlreadyPresented:
                    <#code#>
                case .webContextCancelled:
                    <#code#>
                case .appVerificationUserInteractionFailure:
                    <#code#>
                case .invalidClientID:
                    <#code#>
                case .webNetworkRequestFailed:
                    <#code#>
                case .webInternalError:
                    <#code#>
                case .webSignInUserInteractionFailure:
                    <#code#>
                case .localPlayerNotAuthenticated:
                    <#code#>
                case .nullUser:
                    <#code#>
                case .dynamicLinkNotActivated:
                    <#code#>
                case .invalidProviderID:
                    <#code#>
                case .tenantIDMismatch:
                    <#code#>
                case .unsupportedTenantOperation:
                    <#code#>
                case .invalidDynamicLinkDomain:
                    <#code#>
                case .rejectedCredential:
                    <#code#>
                case .gameKitNotLinked:
                    <#code#>
                case .secondFactorRequired:
                    <#code#>
                case .missingMultiFactorSession:
                    <#code#>
                case .missingMultiFactorInfo:
                    <#code#>
                case .invalidMultiFactorSession:
                    <#code#>
                case .multiFactorInfoNotFound:
                    <#code#>
                case .adminRestrictedOperation:
                    <#code#>
                case .unverifiedEmail:
                    <#code#>
                case .secondFactorAlreadyEnrolled:
                    <#code#>
                case .maximumSecondFactorCountExceeded:
                    <#code#>
                case .unsupportedFirstFactor:
                    <#code#>
                case .emailChangeNeedsVerification:
                    <#code#>
                case .missingOrInvalidNonce:
                    <#code#>
                case .missingClientIdentifier:
                    <#code#>
                case .keychainError:
                    <#code#>
                case .internalError:
                    <#code#>
                case .malformedJWT:
                    <#code#>
                @unknown default:
                    <#code#>
                }
            if let errorCode : AuthErrorCode = AuthErrorCode(rawValue:  )
                let currentUser = Auth.auth().currentUser
                
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    switch error{
                        
                    default:
                        <#code#>
                    }
                    return
                }
                
                // Send token to your backend via HTTPS
                // ...
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
