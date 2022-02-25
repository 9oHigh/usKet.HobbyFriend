//
//  FindFriendsViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/13.
//

import UIKit
import Tabman
import Pageboy
import Then
import RxSwift
import RxCocoa

final class FindFriendsViewController: TabmanViewController {
    
    private var viewControllers: [UIViewController] = []
    
    let changeHobbiesBtn = UIButton().then {
        $0.backgroundColor = R.color.brandGreen()
        $0.setTitle("취미 변경하기", for: .normal)
        $0.titleLabel?.font = .toBodyR14
        $0.layer.cornerRadius = 10
    }
    
    let refreshBtn = UIButton().then {
        $0.backgroundColor = R.color.basicWhite()
        $0.tintColor = R.color.brandGreen()!
        $0.setImage(R.image.refresh(), for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = R.color.brandGreen()!.cgColor
    }
    
    let backView = UIView().then {
        $0.backgroundColor = R.color.basicWhite()
    }
    let arroundViewController = ArroundViewController()
    let recievedViewController = RecievedViewController()
    
    let viewModel = FindFriendsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = R.color.basicWhite()!
        
        [arroundViewController, recievedViewController].forEach { viewController in
            viewControllers.append(viewController)
        }
        if Helper.shared.apiTimer == nil {
         Helper.shared.apiTimer = Timer.scheduledTimer(timeInterval: 5,
                                                      target: self,
                                                      selector: #selector(updateUserMatchStatus(sender:)),
                                                      userInfo: nil,
                                                      repeats: true)
        }
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
        fetchFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hiddenNavBar(false)
        self.tabBarController?.tabBar.isHidden = true
        monitorNetwork()
        fetchFriends()
    }
    
    private func setConfigure() {
        
        // View
        title = "새싹찾기"
        
        // backToHome
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.letfArrow()!, style: .plain, target: self, action: #selector(backToInitial))
        
        // Stop Finding
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기 중단", style: .plain, target: self, action: #selector(stopSearching))
        
        // TabMan
        self.dataSource = self
        
        let bar = TMBarView<TMConstrainedHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
        
        addBar(bar, dataSource: self, at: .top)
        
        bar.backgroundView.style = .flat(color: R.color.basicWhite()!)
        bar.indicator.tintColor = R.color.brandGreen()
        
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        bar.buttons.customize { button in
            button.selectedTintColor =  R.color.brandGreen()
            button.tintColor = R.color.gray6()
        }
        
    }
    
    private func setUI() {
        
        view.addSubview(backView)
        backView.addSubview(changeHobbiesBtn)
        backView.addSubview(refreshBtn)
    }
    
    private func setConstraints() {
        
        backView.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }
        
        changeHobbiesBtn.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerY.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview().multipliedBy(0.775)
        }
        
        refreshBtn.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.centerY.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview().multipliedBy(1.775)
        }
        
    }
    
    private func bind() {
        
        changeHobbiesBtn.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self]_ in
                
                Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.nothing.rawValue)
                
                self?.viewModel.stopFindingFriend(onComletion: { error in
                    guard let error = error else {
                        return
                    }
                    if error == "앗! 누군가가 나의 취미 함께 하기를 수락하였어요!" {
                        Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.matched.rawValue)
                        Helper.shared.apiTimer?.invalidate()
                        Helper.shared.apiTimer = nil
                        // MARK: - 채팅이동
                    } else {
                        self?.showToast(message: error, yPosition: 150)
                    }
                })
                Helper.shared.apiTimer?.invalidate()
                Helper.shared.apiTimer = nil
                Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.nothing.rawValue)
                
                var controllers: Array = self!.navigationController!.viewControllers
                let hobbyViewController = controllers[1] as? InputHobbyViewController
                if controllers[1] is InputHobbyViewController {
                    self?.viewModel.questSurround { friends, _, _ in
                        hobbyViewController?.viewModel.friends = friends
                        controllers[1] = hobbyViewController!
                        self?.navigationController!.popToViewController(controllers[1], animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        refreshBtn.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                self.fetchFriends()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func updateUserMatchStatus(sender: Timer) {
        
        viewModel.checkUserMatch { matched, inform, isTooLong in
            
            guard matched != nil else {

                if isTooLong != nil {
                    Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.nothing.rawValue)
                    
                    self.showToast(message: inform!, yPosition: 150)
                    // 그만두기때문에 Timer 멈추기
                    Helper.shared.apiTimer?.invalidate()
                    Helper.shared.apiTimer = nil
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        // 홈으로 돌아가기 -> 홈인 상태일 수도 있을 듯
                        let controllers: Array = self.navigationController!.viewControllers
                        self.navigationController?.popToViewController(controllers[0], animated: true)
                    }
                } else {
                    self.showToast(message: inform!, yPosition: 150)
                }
                return
            }
            
            if matched == 1 {
                
                Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.matched.rawValue)
                
                self.showToast(message: "\(inform!)님과 매칭되셨습니다.\n잠시 후 채팅방으로 이동합니다", yPosition: 150)
                
                // 호출 종료
                Helper.shared.apiTimer?.invalidate()
                Helper.shared.apiTimer = nil
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.transViewController(nextType: .push, controller: ChattingViewController())
                }
            }
        }
    }
    
    private func fetchFriends() {
        
        viewModel.questSurround { friends, _, error in
            guard let friends = friends else {
                self.showToast(message: error!, yPosition: 150)
                self.arroundViewController.setNoFriends()
                self.recievedViewController.setNoFriends()
                return
            }
            // 탭바에 정보 넣기
            self.arroundViewController.viewModel.friends = friends.fromQueueDB
            self.recievedViewController.viewModel.friends = friends.fromQueueDBRequested
            
            // 값이 있어? -> Reload
            if friends.fromQueueDB.isEmpty {
                self.arroundViewController.setNoFriends()
            } else {
                self.arroundViewController.tableView.removeFromSuperview()
                self.arroundViewController.setFriends()
            }
            
            if friends.fromQueueDBRequested.isEmpty {
                self.recievedViewController.setNoFriends()
            } else {
                self.arroundViewController.tableView.removeFromSuperview()
                self.recievedViewController.setFriends()
            }
        }
    }
    
    @objc
    func backToInitial() {
        guard let navigationController = navigationController else {
            return
        }
        let controllers = navigationController.viewControllers
        self.navigationController?.popToViewController(controllers[0], animated: true)
    }
    
    @objc func stopSearching() {
        print(#function)
        
        viewModel.stopFindingFriend { error in
            guard error == nil else {
                if error! == "앗! 누군가가 나의 취미 함께 하기를 수락하였어요!" {
                    self.showToast(message: error!, yPosition: 150)
                    Helper.shared.apiTimer?.invalidate()
                    Helper.shared.apiTimer = nil
                    
                    Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.matched.rawValue)
                    // MARK: - 채팅화면
                    
                    return
                }
                self.showToast(message: error!, yPosition: 150)
                return
            }
            
            Helper.shared.apiTimer?.invalidate()
            Helper.shared.apiTimer = nil
            
            Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.nothing.rawValue)
            
            let controllers: Array = self.navigationController!.viewControllers
            self.navigationController!.popToViewController(controllers[0], animated: true)
        }
    }
    
}
extension FindFriendsViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        switch index {
        case 0:
            return TMBarItem(title: "주변 새싹")
        case 1:
            return TMBarItem(title: "받은 요청")
        default:
            return TMBarItem(title: "\(index)")
        }
        
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index].viewWillAppear(true)
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        
        return .at(index: 0)
    }
}
