//
//  InputHobbyViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/11.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class InputHobbyViewController: BaseViewController {
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: 0))
    
    let tableView = UITableView().then {
        $0.backgroundColor = R.color.basicWhite()!
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let viewModel = InputHobbyViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConfigure()
    }
    
    override func setUI() {
        
    }
    override func setConfigure() {
        
        // SearchBar
        searchBar.placeholder = "띄어쓰기로 복수입력이 가능해요!"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        //
    }
    
    override func bind() {
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance) // 0.5초 기다림
            .distinctUntilChanged() // 같은 아이템을 받지 않는기능
            .subscribe(onNext: { [weak self]_ in
//                self.items = self.samples.filter{ $0.hasPrefix(t)}
//                self.tableView.reloadData()
                
            }) .disposed(by: disposeBag)
            
    }
}
