//
//  ArroundFriendsViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/13.
//

import UIKit
import RxCocoa
import RxSwift

final class RecievedViewController: BaseViewController {
    
    lazy var noOnewView = NoFriendsView()
    var tableView = UITableView()
    
    let viewModel = FindFriendsTabViewModel()
    let disposeBag = DisposeBag()
    
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
    
    private func acceptFriend(_ otheruid: String) {
        
        let alertView = self.generateAlertView(inform: "취미 같이 하기를 수락할까요?", subInform: "요청이 수락되면 채팅창에서 대화를 나눌 수 있어요")
        
        alertView.okButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ [ weak self ] _ in
                self?.showToast(message: "")
                self?.viewModel.acceptFriend(parm: otheruid, onCompletion: { message, isMatched in
                    
                    guard isMatched != nil else {
                        if message == "앗! 누군가가 나의 취미 함께 하기를 수락하였어요!"{
                            self?.showToast(message: message!)
                            // MARK: - 분기처리
                            self?.viewModel.userCheckIsMatch(onCompletion: { _, _, _ in })
                            return
                        }
                        self?.showToast(message: message!)
                        return
                    }
                    // 매칭 성공
                    alertView.dismiss(animated: true, completion: nil)
                    // MARK: - 채팅화면
                })
            })
            .disposed(by: disposeBag)
        
        alertView.cancelButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                alertView.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.present(alertView, animated: true, completion: nil)
    }
}
extension RecievedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendsTableViewCell.identifier, for: indexPath) as! FindFriendsTableViewCell
        
        cell.infoView.setBtnColor(title: "수락하기", color: R.color.systemSuccess()!)
        cell.infoView.foldView.nameLabel.text = viewModel.friends[indexPath.row].nick
        cell.infoView.foldView.titleView.reputation = viewModel.friends[indexPath.row].reputation
        
        if viewModel.friends[indexPath.row].reviews.isEmpty {
            
            cell.infoView.foldView.reviewOpenButton.isHidden = true
        } else {
            
            cell.infoView.foldView.reviewOpenButton.isHidden = false
            cell.infoView.foldView.reviewTextView.text = viewModel.friends[indexPath.row].reviews[0]
        }

        cell.buttonAction = {
            self.acceptFriend(self.viewModel.friends[indexPath.row].uid)
        }
        
        if viewModel.friends.count == indexPath.row + 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        }
      
        return cell
    }
}
