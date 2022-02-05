//
//  AlertView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/28.
//

import UIKit
import RxCocoa
import RxSwift

final class AlertView : BaseViewController {
    
    let forwardView = UIView()
    
    let informLabel = UILabel()
    let subInformLabel = UILabel()
    
    let cancelButton = UIButton()
    let okButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
    }
    
    override func setConfigure() {
        //Main
        view.backgroundColor = R.color.basicBlack()!.withAlphaComponent(0.5)
        
        //Sub
        forwardView.backgroundColor = R.color.basicWhite()!
        forwardView.layer.cornerRadius = 15
        
        //label
        informLabel.font = .toBodyM16
        informLabel.numberOfLines = 0
        informLabel.textColor = R.color.basicBlack()!
        informLabel.textAlignment = .center
        
        subInformLabel.font = .toTitleR14
        subInformLabel.numberOfLines = 0
        subInformLabel.textColor = R.color.basicBlack()!
        subInformLabel.textAlignment = .center
        
        //buttons
        cancelButton.titleLabel?.font = .toTitleR14
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(R.color.basicBlack()!, for: .normal)
        cancelButton.backgroundColor = R.color.gray3()!
        cancelButton.layer.cornerRadius = 10
        
        okButton.titleLabel?.font = .toTitleR14
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(R.color.basicWhite()!, for: .normal)
        okButton.backgroundColor = R.color.brandGreen()!
        okButton.layer.cornerRadius = 10
    }
    
    override func setUI() {
        
        view.addSubview(forwardView)
        
        forwardView.addSubview(informLabel)
        forwardView.addSubview(subInformLabel)
        
        forwardView.addSubview(cancelButton)
        forwardView.addSubview(okButton)
    }
    
    override func setConstraints() {
     
        forwardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        informLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        subInformLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.centerX.equalToSuperview().multipliedBy(0.55)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        okButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.centerX.equalToSuperview().multipliedBy(1.45)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}
