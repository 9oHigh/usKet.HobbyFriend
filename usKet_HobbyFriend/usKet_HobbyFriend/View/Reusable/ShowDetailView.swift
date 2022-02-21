//
//  ShowDetailView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/22.
//

import UIKit
import Then

final class ShowDetailView: BaseViewController {
    
    let forwardView = UIView().then {
        
        $0.backgroundColor = R.color.basicWhite()!
    }
    
    let informLabel = UILabel().then {
        
        $0.textColor = R.color.basicBlack()!
        $0.textAlignment = .center
        $0.font = .toTitleM14
    }
    
    let subInformLabel = UILabel().then {
        $0.textColor = R.color.brandGreen()!
        $0.textAlignment = .center
        $0.font = .toTitleR14
    }
    
    // 콜렉션뷰 셀은 기존의 것으로 사용
    
    let textView = UITextView().then {
        $0.backgroundColor = R.color.gray5()!
        $0.textColor = R.color.basicBlack()!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
}
extension ShowDetailView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300
    }
}
