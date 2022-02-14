//
//  ArroundFriendsViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/13.
//

import UIKit

final class ArroundViewController: BaseViewController {
    
    lazy var noOnewView = NoFriendsView()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        monitorNetwork()
    }
    
    override func setConfigure() {
        
        view.backgroundColor = R.color.basicWhite()!
        
    }
    
    override func setUI() {
       
    }
    
    override func setConstraints() {
       
    }
    
    func setNoFriends() {
        
        noOnewView.informLabel.text = "아쉽게도 주변에 새싹이 없어요 ㅠㅜ"
        
        view.addSubview(noOnewView)
        
        noOnewView.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.25)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.trailing.equalToSuperview()
        }
    }
}
