# 새싹 프렌즈🌱 [ 진행중 ]
#### - 위치기반의 취미 공유 애플리케이션 
#### - [프로토타입✨](https://www.figma.com/file/lr65iNqhERfPv7SGp267KB/SeSAC?node-id=27%3A1397)
### 주요 기술 스택
`R.swift` `SwiftLint` `Firebase` `Then` `SnapKit` `Moya` `RESTful API` `RxCocoa` `MVVM` 

##  ✔ 학습 및 적용 🏃🏻‍♂️

### 1. R.swift
  * 이미지, 폰트 등 Resource를 초기화하는 방식의 형태로 사용했었다. 이번 프로젝트에서는 R.swift를 활용하여 리소스를 관리 및 적용함으로써 코드를 간소화할 수 있었다.
    * [SPM을 이용해 R.swift를 설치할시 발생했던 이슈 정리 및 해결 방법](https://pooh-footprints.tistory.com/38) 🏋🏻‍♀️

### 2. SwiftLint
  * 현업에서 자주 사용하고 있는 코딩 컨벤션 라이브러리인 SwiftLint를 학습 및 적용

    ```
    disabled_rules:
      - line_length
      - trailing_whitespace
      - force_cast
      - force_unwrapping
    excluded:
      - Pods
      - Packages
      - usKet_HobbyFriend/Resource/R.generated.swift
    analyzer_rules:
      - unused_declaration
      - unused_import
    opt_in_rules:
      - empty_count
      - empty_string
    ```
    
### 3. Firebase

  * 유저간의 요청 / 수락 / 기타 알림을 위해 Firebase Cloud Messaging을 사용

      <details>
      <summary> Appdelegate </summary>
      <div markdown="1">    
        
      * UNUserNotificationCenter를 이용해 알림 등록  

        ```swift
          import Firebase

          @main
          class AppDelegate: UIResponder, UIApplicationDelegate {

            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

                FirebaseApp.configure()

                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self

                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }

                application.registerForRemoteNotifications()

                ···

            }
        ```
        
       * extension Appdelegate : MessagingDelegate,UNUserNotificationCenterDelegate 채택 
          * Messaging 함수 -> FCM 토큰을 UserDefaults로 관리
        
            ```swift
              extension AppDelegate: MessagingDelegate {

                    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

                        lazy var signup = Helper()

                        guard let fcmToken = fcmToken else {
                            signup.registerUserData(userDataType: .FCMtoken, variable: "None")
                            return
                        }
                        signup.registerUserData(userDataType: .FCMtoken, variable: fcmToken)

                    }

                    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

                            completionHandler(UIBackgroundFetchResult.newData)
                     }
                }

                extension AppDelegate: UNUserNotificationCenterDelegate {

                    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler                                        completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                        completionHandler([ .banner, .badge, .sound])
                    }

                    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler                                   completionHandler: @escaping () -> Void) {
                        completionHandler()
                    }
                }
            ```
        
      </div>
      </details>
    
### 4. Moya, RESTful API
  * URLSession부터 Alamofire 그리고 이번 프로젝트에서는 Moya를 사용해 RESTful API를 구현
  * 회원가입 플로우 이후 홈 지점부터 구현해야하는 Endpoint, Codable 모델 등이 늘어나 모듈화 및 가독성을 위해 Moya를 채택
  * [Moya 적용기](https://pooh-footprints.tistory.com/39) 🏋🏻‍♀️


<br></br>


## ✔️ 개발 이슈 및 요구사항 해결

[1] [UICollectionView의 Cell을 왼쪽 정렬하기](https://pooh-footprints.tistory.com/43)

[2] [SnapKit updateConstraint 적용](https://pooh-footprints.tistory.com/44)

[3] [유저의 매칭상태를 확인하기 위한 API 반복호출](https://pooh-footprints.tistory.com/45)

[4] [셀안의 버튼에 이벤트주기](https://pooh-footprints.tistory.com/46)

[5] [NavigationController의 SetViewController](https://pooh-footprints.tistory.com/47)

[6] [intrinsicContentSize를 이용해 셀의 크기를 동적으로 사용하기](https://pooh-footprints.tistory.com/50)

[7] [DropDownView를 구현하는 방법, UI](https://pooh-footprints.tistory.com/55)

[8] [Chatting UI를 구성하는 방법 1](https://pooh-footprints.tistory.com/56)

[9] [Chatting UI를 구성하는 방법 2](https://pooh-footprints.tistory.com/57) 
