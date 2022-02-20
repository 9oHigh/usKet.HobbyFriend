//
//  ArroundFriendsViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/13.
//

import UIKit
import RxSwift
import RxCocoa

final class ArroundViewController: BaseViewController {
    
    lazy var noOnewView = NoFriendsView()
    var tableView = UITableView()
    
    let viewModel = FindFriendsTabViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.color.basicWhite()!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
        viewModel.friends.isEmpty ? setNoFriends() : setFriends()
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
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-(Double(view.frame.height) * 0.1))
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
        
        let alertView = self.generateAlertView(inform: "취미 같이 하기를 요청할게요!", subInform: "요청이 수락되면 30분후에 리뷰를 남길 수 있어요.")
        
        alertView.okButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ [ weak self ] _ in
                self?.viewModel.requestFriend(parm: otheruid) { message, isMatched in
                    
                    guard isMatched == true else {
                        // 401
                        if message! == "토큰을 갱신중입니다."{
                            self?.requestFriend(otheruid)
                            return
                        }
                        // 200,202,else
                        alertView.dismiss(animated: true, completion: nil)
                        self?.showToast(message: message!, yPosition: 150)
                        return
                    }
                    // 201
                    // 여기서 200 이면 -> 토스트 + 채팅
                    alertView.dismiss(animated: true, completion: nil)
                    self?.showToast(message: message!)

                    DispatchQueue.main.async {
                        self?.viewModel.acceptFriend(parm: otheruid) { acceptMessage, acceptMatched in
                            guard acceptMatched == true else {
                                if acceptMessage! == "앗! 누군가가 나의 취미 함께 하기를 수락하였어요!" {
                                    // MARK: - 분기처리
                                    self?.viewModel.userCheckIsMatch(onCompletion: { _, _, _ in })
                                    self?.showToast(message: acceptMessage!)
                                }
                                self?.showToast(message: acceptMessage!)
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                // MARK: - 채팅화면
                            }
                        }
                    }
                    
                }
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
    
    private func fetchReviews(reviews: [String]) {
        print(reviews)
        let reviews = reviews
        let reviewViewController = ReviewViewController()
        reviewViewController.viewModel.reviews = reviews
        self.navigationController?.pushViewController(reviewViewController, animated: true)
    }
}
extension ArroundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendsTableViewCell.identifier, for: indexPath) as! FindFriendsTableViewCell
        
        cell.infoView.setBtnColor(title: "요청하기", color: R.color.systemError()!)
        cell.infoView.foldView.nameLabel.text = viewModel.friends[indexPath.row].nick
        
        if viewModel.friends[indexPath.row].reviews.isEmpty {
            
            cell.infoView.foldView.reviewOpenButton.isHidden = true
            
        } else if viewModel.friends[indexPath.row].reviews.count > 1 { // 한개초과
            
            cell.infoView.foldView.reviewOpenButton.isHidden = false
            cell.infoView.foldView.reviewTextView.textColor = R.color.basicBlack()!
            cell.infoView.foldView.reviewTextView.text = viewModel.friends[indexPath.row].reviews[0]
            cell.reviewAction = {
                self.fetchReviews(reviews: self.viewModel.friends[indexPath.row].reviews)
            }
        } else { // 한개
            
            cell.infoView.foldView.reviewOpenButton.isHidden = true
            cell.infoView.foldView.reviewTextView.textColor = R.color.basicBlack()!
            cell.infoView.foldView.reviewTextView.text = viewModel.friends[indexPath.row].reviews[0]
        }
        
        cell.infoView.foldView.titleView.reputation = viewModel.friends[indexPath.row].reputation
        
        cell.buttonAction = {
            self.requestFriend(self.viewModel.friends[indexPath.row].uid)
        }
        
        if viewModel.friends.count == indexPath.row + 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        }
        
        return cell
    }
}
