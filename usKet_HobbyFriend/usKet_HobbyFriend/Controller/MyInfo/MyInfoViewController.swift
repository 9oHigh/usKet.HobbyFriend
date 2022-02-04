//
//  HomeTabViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class MyInfoViewController : BaseViewController {
    
    let tableView = UITableView()
    let viewModel = MyInfoViewModel()
    let disposeBag = DisposeBag()
    
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
        bind()
        monitorNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    override func setConfigure(){
        
        //View
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        //TableView
        tableView.isScrollEnabled = false //스크롤 불가능
        tableView.separatorStyle = .singleLine
        
        tableView.backgroundColor = R.color.basicWhite()
        tableView.separatorColor = R.color.gray2()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        tableView.register(MyInfoHeaderTableViewCell.self,forCellReuseIdentifier: MyInfoHeaderTableViewCell.identifier)
        tableView.register(MyInfoTableViewCell.self,forCellReuseIdentifier: MyInfoTableViewCell.identifier)
    }
    
    override func setUI(){
        
        view.addSubview(tableView)
    }
    
    override func setConstraints(){
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        //First Delegate
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        //Second Bind
        //신기하게도 Datasource를 채택하지 않아도 적용이 되는!
        viewModel.myInfoMenu
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items){ tableView,row,item -> UITableViewCell in
                if row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoHeaderTableViewCell.identifier, for: IndexPath.init(row: row, section: 0)) as! MyInfoHeaderTableViewCell
                    cell.setUpdate(myInfo: item)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.identifier, for: IndexPath.init(row: row, section: 0)) as! MyInfoTableViewCell
                    cell.setUpdate(myInfo: item)
                    return cell
                }
            }.disposed(by: disposeBag)
        
        //Third function
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance) //메인쓰레드에서 동작
            .subscribe(onNext:{ [weak self] indexPath in //구독 -> 이벤트 발생
                //MARK: ViewModel + API
                //중요한건 여기서 서버에 타야된다 ( 서버처리 )
                if indexPath.row == 0 {
                    let viewController = MyInfoDetailViewController()
                    
                    self?.viewModel.getUserInfo { [weak self] user,error in
                        guard error == nil else {
                            if error != "미가입 회원입니다."{
                                self?.showToast(message: error!)
                            } else {
                                self?.view.window?.rootViewController = OnboardViewController()
                                self?.view.window?.makeKeyAndVisible()
                            }
                            return
                        }
                        guard let user = user else {
                            return
                        }
                        viewController.viewModel.user = user
                        self?.transViewController(nextType: .push, controller: viewController)
                    }
                }
                else {
                    self?.tableView.deselectRow(at: indexPath, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
}
//셀의 높이는 어쩔수 없군
//https://stackoverflow.com/questions/43486597/how-to-write-height-for-row-in-rxswift
extension MyInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let headerCellHeight : CGFloat = UIScreen.main.bounds.height >= 736 ? 95 : 85
        let cellHeight : CGFloat = UIScreen.main.bounds.height >= 736 ? 85 : 75
        
        return indexPath.row == 0 ? headerCellHeight : cellHeight
    }
}
