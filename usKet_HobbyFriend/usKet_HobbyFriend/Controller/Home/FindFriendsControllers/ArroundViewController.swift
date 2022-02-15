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
    
    let viewModel = FindFriendsTabViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        viewModel.friends.isEmpty ? setNoFriends() : setFriends()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
        viewModel.friends.isEmpty ? setNoFriends() : setFriends()
    }
    
    override func setConfigure() {
        // View
        view.backgroundColor = R.color.basicWhite()!
    }
    
    func setFriends() {
        
        noOnewView.removeFromSuperview()
        tableView.backgroundColor = R.color.basicWhite()!
        tableView.register(FindFriendsTableViewCell.self, forCellReuseIdentifier: FindFriendsTableViewCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 530
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.reloadData()
    }
    
    func setNoFriends() {
        tableView.removeFromSuperview()
        noOnewView.informLabel.text = "아쉽게도 주변에 새싹이 없어요 ㅠㅜ"
        
        view.addSubview(noOnewView)
        
        noOnewView.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.25)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func requestFriend(_ otheruid: String) {
        print("요청할겜")
    }
    
}
extension ArroundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendsTableViewCell.identifier, for: indexPath) as! FindFriendsTableViewCell
        cell.selectionStyle = .none
        cell.infoView.setBtnColor(title: "요청하기", color: R.color.systemError()!)
        cell.infoView.foldView.nameLabel.text = viewModel.friends[indexPath.row].nick
        if viewModel.friends[indexPath.row].reviews.isEmpty {
            cell.infoView.foldView.reviewOpenButton.isHidden = true
        } else {
            cell.infoView.foldView.reviewOpenButton.isHidden = false
            cell.infoView.foldView.reviewTextView.text = viewModel.friends[indexPath.row].reviews[0]
        }
        cell.infoView.foldView.titleView.reputation = viewModel.friends[indexPath.row].reputation
        cell.buttonAction = {
            self.requestFriend("")
        }
        
        // MARK: - 사람별로 데이터 넣어주기
        
        return cell
    }
}
