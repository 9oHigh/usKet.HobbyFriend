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

enum SearchErrorType: String {
    
    case notAllowed = "최소 한 자 이상, 최대 8글자까지 작성 가능합니다"
    case alreadyInput = "이미 등록된 취미입니다"
    case alreadyFull = "이미 8개의 취미가 등록되어있습니다."
}

final class InputHobbyViewController: BaseViewController {
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: 0))
    
    let collectionView: UICollectionView = {
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = R.color.basicWhite()!
        
        return collectionView
    }()
    
    let findButton = UIButton().then {
        
        $0.backgroundColor = R.color.brandGreen()!
        $0.setTitle("새싹찾기", for: .normal)
        $0.setTitleColor(R.color.basicWhite()!, for: .normal)
        $0.titleLabel?.font = .toBodyR14
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(findFriends), for: .touchUpInside)
    }
    
    let viewModel = InputHobbyViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        monitorNetwork()
        addKeyBoardListener()
        collectionView.reloadData()
    }
    
    override func setConfigure() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        // SearchBar
        searchBar.placeholder = "띄어쓰기로 복수입력이 가능해요!"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(InputHobbyCollectionViewCell.self, forCellWithReuseIdentifier: InputHobbyCollectionViewCell.identifier)
        
        collectionView.register(CollectionSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionSectionHeader.identifier
        )
        
        // viewModel
        viewModel.getUserHobbies()
    }
    
    override func setUI() {
        
        view.addSubview(collectionView)
        view.addSubview(findButton)
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        findButton.snp.makeConstraints { make in
            make.bottom.equalTo(-25)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).inset(30)
            make.height.equalTo(50)
        }
    }
    
    override func bind() {
        
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance) // 0.5초 기다림
            .subscribe(onNext: { [weak self] hobby in
                
                let hobbies = hobby.components(separatedBy: " ")

                hobbies.forEach {
                    
                    if $0.count > 8 {
                        self?.showToast(message: SearchErrorType.notAllowed.rawValue, yPosition: 150)
                    } else if self!.viewModel.wantItems.contains($0) {
                        self?.showToast(message: SearchErrorType.alreadyInput.rawValue, yPosition: 150)
                    } else if self!.viewModel.wantItems.count > 8 {
                        self?.showToast(message: SearchErrorType.alreadyFull.rawValue, yPosition: 150)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: {
                var texts: [String] = []
                guard let text = self.searchBar.text else {
                    self.showToast(message: "취미를 입력해주세요.", yPosition: 150)
                    return
                }
                texts = text.components(separatedBy: " ")
                
                texts.forEach { item in
                    if self.viewModel.wantItems.contains(item) {
                        self.showToast(message: SearchErrorType.alreadyInput.rawValue, yPosition: 150)
                    } else if self.viewModel.wantItems.count > 8 {
                        self.showToast(message: SearchErrorType.alreadyFull.rawValue, yPosition: 150)
                    } else {
                        self.viewModel.wantItems.append(item)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
                self.viewModel.searchItems.removeAll()
                self.searchBar.text = nil
            })
            .disposed(by: disposeBag)
    }
    // 키보드 노티
    private func addKeyBoardListener() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 새싹찾기로 넘어갈시 제거
    private func removeKeyBoardListener() {
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.findButton.layer.cornerRadius = 0
        
        self.findButton.snp.updateConstraints { make in
            
            make.width.equalTo(self.view.snp.width)
            make.bottom.equalTo(-keyboardSize.height)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        
        self.findButton.layer.cornerRadius = 10
        
        self.findButton.snp.updateConstraints { make in
            
            make.width.equalTo(view.snp.width).inset(30)
            make.bottom.equalTo(-25)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc
    private func findFriends() {
        viewModel.findFriends { error, isNavigation in
            guard error == nil else {
                self.showToast(message: error!, yPosition: 150)
                if isNavigation != nil && isNavigation! {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.tabBarController?.selectedIndex = 3
                    }
                }
                return
            }
            Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.matching.rawValue)
            
            self.transViewController(nextType: .push, controller: FindFriendsViewController())
        }
    }
}
extension InputHobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return viewModel.userItems.count
        } else {
            return viewModel.wantItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionSectionHeader.identifier, for: indexPath) as! CollectionSectionHeader
        
        sectionHeader.sectionHeaderlabel.text = indexPath.section == 0 ? "지금 주변에는" : "내가 하고싶은"
        
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputHobbyCollectionViewCell.identifier, for: indexPath) as! InputHobbyCollectionViewCell
        
        if indexPath.section == 0 {
            
            viewModel.userItems[indexPath.row].type == .recommend ?
            cell.matchUserColor(nameColor: .red, borderColor: .red) : cell.matchUserColor(nameColor: .black, borderColor: .lightGray)
            
            cell.hobbyLabel.text = viewModel.userItems[indexPath.row].hobby
            
        } else {
            cell.matchMyColor()
            cell.hobbyLabel.text = viewModel.wantItems[indexPath.row] + "  X"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        
        label.text = indexPath.section == 0 ? viewModel.userItems[indexPath.row].hobby : viewModel.wantItems[indexPath.row] + "  X"
        
        return CGSize(width: label.intrinsicContentSize.width + 10, height: label.intrinsicContentSize.height + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if viewModel.wantItems.count >= 8 {
                self.showToast(message: SearchErrorType.alreadyFull.rawValue, yPosition: 150)
            } else if viewModel.wantItems.contains(viewModel.userItems[indexPath.row].hobby) {
                self.showToast(message: SearchErrorType.alreadyInput.rawValue, yPosition: 150)
            } else {
                viewModel.wantItems.append(viewModel.userItems[indexPath.row].hobby)
                collectionView.reloadData()
            }
        } else {
            viewModel.wantItems.remove(at: indexPath.row)
            collectionView.reloadData()
        }
    }
}
extension InputHobbyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 15, right: 0)
    }
}
