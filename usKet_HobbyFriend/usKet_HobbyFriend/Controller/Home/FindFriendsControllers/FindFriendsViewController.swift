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

//https://developer-p.tistory.com/161 참고

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
    
    let viewModel = FindFriendsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arroundViewController = ArroundViewController()
        let recievedViewController = RecievedViewController()
        
        [arroundViewController, recievedViewController].forEach { viewController in
            viewControllers.append(viewController)
        }
        
        setConfigure()
        setUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    private func setConfigure() {
        
        // View
        title = "새싹찾기"
        self.view.backgroundColor = R.color.basicWhite()
        
        // backToHome
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.letfArrow()!, style: .plain, target: self, action: #selector(backToInitial(sender:)))
        
        // Stop Finding
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기 중단", style: .plain, target: self, action: #selector(stopSearching))
        
        // TabMan
        self.dataSource = self
        
        let bar = TMBarView<TMConstrainedHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
        
        addBar(bar, dataSource: self, at: .top)
        
        bar.backgroundView.style = .clear
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
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.085)
            make.centerX.equalToSuperview()
        }
        
        changeHobbiesBtn.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(0.75)
        }
        
        refreshBtn.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.75)
        }
    }
    
    @objc
    func backToInitial(sender: AnyObject) {
        let controllers: Array = self.navigationController!.viewControllers
        self.navigationController!.popToViewController(controllers[0], animated: true)
    }
    // 중단 로직
    @objc func stopSearching() {
        viewModel.stopFindingFriend { error in
            guard error == nil else {
                self.showToast(message: error!)
                return
            }
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
        
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        
        return .at(index: 0)
    }
    
}
