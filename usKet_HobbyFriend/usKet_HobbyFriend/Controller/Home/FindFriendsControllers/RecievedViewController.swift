//
//  recievedViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/13.
//

import UIKit

final class RecievedViewController: BaseViewController {
    
    lazy var noOnewView = NoFriendsView()
    var tableView = UITableView()
    
    let viewModel = FindFriendsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        monitorNetwork()
    }
    
    override func setConfigure() {
        // View
        view.backgroundColor = R.color.basicWhite()!
        
        // TableView
        tableView.backgroundColor = R.color.basicWhite()!
        tableView.register(FindFriendsTableViewCell.self, forCellReuseIdentifier: FindFriendsTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func setUI() {
        
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    func setNoFriends() {
        
        noOnewView.informLabel.text = "아직 받은 요청이 없어요 ㅠㅜ"
        
        view.addSubview(noOnewView)
        
        noOnewView.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.25)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func removeNoFriends() {
        
        noOnewView.removeFromSuperview()
    }
    
    private func acceptFriend(_ otheruid: String) {
        
    }
    
}
extension RecievedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendsTableViewCell.identifier, for: indexPath) as! FindFriendsTableViewCell
        
        cell.infoView.setBtnColor(title: "수락하기", color: UIColor.blue)
        
        cell.buttonAction = {
            self.acceptFriend("")
        }
        
        return cell
    }
    
}
