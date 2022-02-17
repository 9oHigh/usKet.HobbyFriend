//
//  ButtonsView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/26.
//

import UIKit
import RxSwift
 import RxCocoa

final class MyInfoCollectionVeiw: UIView {
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(MyInfoTitleCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoTitleCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        return collectionView
    }()
    
    let viewModel = MyInfoViewModel()
    let disposeBag = DisposeBag()
    var reputation: [Int] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        addSubview(collectionView)
    }
    
    func setConfigure() {
        
        backgroundColor = UIColor(resource: R.color.basicWhite)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind() {
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.myInfoTitle
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: MyInfoTitleCollectionViewCell.identifier, cellType: MyInfoTitleCollectionViewCell.self)) { _, item, cell in
                
                if self.viewModel.user != nil {
                    
                    self.viewModel.user?.reputation.forEach({ color in
                        if color == 0 {
                            cell.titleButton.setTitleColor(R.color.basicBlack(), for: .normal)
                            cell.titleButton.backgroundColor = R.color.basicWhite()!
                        } else {
                            cell.titleButton.setTitleColor(R.color.basicWhite(), for: .normal)
                            cell.titleButton.backgroundColor = R.color.brandGreen()!
                        }
                    })
                } else {
                    
                    self.reputation.forEach { color in
                        if color == 0 {
                            cell.titleButton.setTitleColor(R.color.basicBlack(), for: .normal)
                            cell.titleButton.backgroundColor = R.color.basicWhite()!
                        } else {
                            cell.titleButton.setTitleColor(R.color.basicWhite(), for: .normal)
                            cell.titleButton.backgroundColor = R.color.brandGreen()!
                        }
                    }
                }
                cell.setUpdate(myTitle: item)
            }
            .disposed(by: disposeBag)
    }
}
extension MyInfoCollectionVeiw: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let cellWidth = (width - 8) / 2
        
        return CGSize(width: cellWidth, height: cellWidth * 0.2)
    }
}
