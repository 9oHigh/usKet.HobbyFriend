//
//  ShowDetailView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/22.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class ShowDetailView: BaseViewController {
    
    let forwardView = UIView().then {
        $0.backgroundColor = R.color.basicWhite()!
        $0.layer.cornerRadius = 15
    }
    
    let informLabel = UILabel().then {
        $0.textColor = R.color.basicBlack()!
        $0.textAlignment = .center
        $0.font = .toTitleM14
    }
    
    let closeButton = UIButton().then {
        $0.setImage(R.image.xmark()!, for: .normal)
        $0.tintColor = R.color.basicBlack()!
        $0.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
    }
    
    let subInformLabel = UILabel().then {
        $0.textColor = R.color.brandGreen()!
        $0.textAlignment = .center
        $0.font = .toTitleR14
    }
    
    // 콜렉션뷰 셀은 기존의 것 3 * 2 / 새로운 것 2 * 3
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = R.color.basicWhite()!
        
        return collectionView
    }()
    
    let textView = UITextView().then {
        $0.backgroundColor = R.color.gray1()!
        $0.textColor = R.color.basicBlack()!
        $0.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.layer.cornerRadius = 10
        $0.font = .toBodyR14
    }
    
    let checkButton = UIButton().then {
        $0.setTitleColor(R.color.basicWhite()!, for: .normal)
        $0.backgroundColor = R.color.brandGreen()!
        $0.layer.cornerRadius = 10
    }
    
    let viewModel = ChatViewModel.shared
    let disposeBag = DisposeBag()
    var cellType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    // 진입 이전에
    func setUpViewController(main: String, sub: String, type: Int, btnTitle: String) {
        informLabel.text = main
        subInformLabel.text = sub
        cellType = type
        checkButton.setTitle(btnTitle, for: .normal)
    }
    
    override func setConfigure() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        textView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyInfoTitleCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoTitleCollectionViewCell.identifier)
    }
    
    override func setUI() {
        
        view.addSubview(forwardView)
        
        forwardView.addSubview(informLabel)
        forwardView.addSubview(closeButton)
        forwardView.addSubview(subInformLabel)
        forwardView.addSubview(collectionView)
        forwardView.addSubview(textView)
        forwardView.addSubview(checkButton)
    }
    
    override func setConstraints() {
        if cellType == 0 {
            forwardView.snp.makeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.55)
                make.width.equalToSuperview().multipliedBy(0.95)
                make.center.equalToSuperview()
            }
            
        } else {
            forwardView.snp.makeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.5)
                make.width.equalToSuperview().multipliedBy(0.95)
                make.center.equalToSuperview()
            }
        }

        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        textView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.25)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        informLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(subInformLabel.snp.top)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(informLabel)
            make.height.equalTo(informLabel.snp.height)
            make.width.equalTo(closeButton.snp.height)
            make.trailing.equalTo(-10)
        }
        
        subInformLabel.snp.makeConstraints { make in
            make.top.equalTo(informLabel.snp.bottom)
            make.trailing.leading.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.125)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc
    func closeTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func changeColor(_ isColored: Int, _ indexPath: Int) {
        
        if viewModel.colors[indexPath] == 0 {
            viewModel.colors[indexPath] = 1
        } else {
            viewModel.colors[indexPath] = 0
        }
        collectionView.reloadData()
    }
    
}
extension ShowDetailView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300
    }
}
extension ShowDetailView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoTitleCollectionViewCell.identifier, for: indexPath) as? MyInfoTitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        if cellType == 0 {
            cell.setUpdate(myTitle: viewModel.reviewUser[indexPath.row])
            cell.updateColor(isColored: viewModel.colors[indexPath.row])
            cell.buttonAction = {
                self.changeColor(self.viewModel.colors[indexPath.row], indexPath.row)
            }
        } else {
            cell.setUpdate(myTitle: viewModel.reportUser[indexPath.row])
            cell.updateColor(isColored: viewModel.colors[indexPath.row])
            cell.buttonAction = {
                self.changeColor(self.viewModel.colors[indexPath.row], indexPath.row)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.cellType == 0 {
            let width = collectionView.bounds.width
            let cellWidth = (width - 8) / 2
            return CGSize(width: cellWidth, height: cellWidth * 0.2)
        } else {
            let width = collectionView.bounds.width
            let cellWidth = (width - 16) / 3
            return CGSize(width: cellWidth, height: cellWidth * 0.4)
        }
    }
}
