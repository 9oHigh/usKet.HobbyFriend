//
//  MyInfoViewModel.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

import RxSwift
import UIKit

class MyInfoViewModel {
    
    //BehaviorSubject는 초기값을 가지고 있는 subject
    // +subscribe가 발생하면, 발생한 시점 이전에 발생한 이벤트 중 가장 최신의 이벤트를 전달받는다. (다시 말하면 지속적으로 이벤트를 하나이상은 가지고 있게 되는 케이스)
    
    var myInfoMenu = BehaviorSubject<[MyInfo]>(value: [
        MyInfo(image: R.image.profileImg()!, name: UserDefaults.standard.string(forKey: "nick")!),
        MyInfo(image: R.image.notice()!, name: "공지사항"),
        MyInfo(image: R.image.qna()!, name: "자주 묻는 질문"),
        MyInfo(image: R.image.faq()!, name: "1:1 문의"),
        MyInfo(image: R.image.setting_alarm()!, name: "알림 설정"),
        MyInfo(image: R.image.permit()!, name: "이용 약관")
    ])
    
    var myInfoTitle = BehaviorSubject<[MyTitle]>(value: [
        MyTitle(title: "좋은 매너"),
        MyTitle(title: "정확한 시간 약속"),
        MyTitle(title: "빠른 응답"),
        MyTitle(title: "친절한 성격"),
        MyTitle(title: "능숙한 취미 실력"),
        MyTitle(title: "유익한 시간")
    ])
    
    
}
