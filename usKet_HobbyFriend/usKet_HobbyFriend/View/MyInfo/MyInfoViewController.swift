//
//  HomeTabViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/23.
//

import UIKit

class MyInfoViewController : BaseViewController {
    
    var tableView = UITableView()
    var headerView : ProfileImageButtonView = {
        
        let headerView = ProfileImageButtonView()
        
        headerView.profileImageView.contentMode = .scaleAspectFit
        headerView.profileImageView.image = UIImage(resource: R.image.profileImg)
        
        headerView.nameLabel.font = UIFont.toTitleM16!
        headerView.nameLabel.textColor = UIColor(resource: R.color.basicBlack)
        headerView.nameLabel.text = UserDefaults.standard.string(forKey: "nick") ?? "다홍치마" // viewModel 로직 수정 필요
        
        headerView.buttonReSize(height: 50, width: 50)
        headerView.customButton.setImage(UIImage(resource: R.image.rightArrow)!, for: .normal)
        headerView.customButton.addTarget(self, action: #selector(onDetailView(_:)), for: .touchUpInside)
        
        return headerView
    }()
    
    var imageSet : [UIImage] = [
        UIImage(resource: R.image.notice)!,
        UIImage(resource: R.image.faq)!,
        UIImage(resource: R.image.qna)!,
        UIImage(resource: R.image.setting_alarm)!,
        UIImage(resource: R.image.permit)!
    ]
    
    var stringSet : [String] = [
        "공지사항","자주 묻는 질문","1:1 문의","알림 설정","이용약관"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "내정보"
        navigationController?.navigationBar.titleTextAttributes = [
            .font : UIFont.toTitleM14!,
            .foregroundColor : UIColor(resource: R.color.basicBlack)!
        ]
        
        setConfigure()
        setUI()
        setConstraints()
        monitorNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    override func setConfigure(){
        
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false //스크롤 불가능
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) //좌우가 왜 다를깡
        tableView.rowHeight = UIScreen.main.bounds.height >= 736 ? 75 : 65 // 8+ : 8
        tableView.sectionHeaderHeight = UIScreen.main.bounds.height >= 736 ? 85 : 75 // 8+ : 8
        
        tableView.separatorColor = UIColor(resource: R.color.gray3)
        tableView.backgroundColor = UIColor(resource: R.color.basicWhite)
    }
    
    override func setUI(){
        
        view.addSubview(tableView)
    }
    
    override func setConstraints(){
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    @objc
    func onDetailView(_ sender : UIButton){
        //MARK: 서버 작업 - MVVM + RxAlamofire
        
        self.transViewController(nextType: .push, controller: MyInfoDetailViewController())
    }
}

extension MyInfoViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default , reuseIdentifier: "Cell")
        
        cell.imageView?.image = imageSet[indexPath.row]
        cell.textLabel?.font = UIFont.toTitleR16
        cell.textLabel?.text = stringSet[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
    }
    
}
