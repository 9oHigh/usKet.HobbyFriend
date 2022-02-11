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
    var reputation: [Int] = []
    
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
        
        // 바로 셀을 등록하고 사용할 수 있음
        // 받아오는 모델이 String이 아닌 숫자이므로
        // MARK: 모델 개선 + 뷰모델 컬러 부여 고민
        viewModel.myInfoTitle
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: MyInfoTitleCollectionViewCell.identifier, cellType: MyInfoTitleCollectionViewCell.self)) { _, item, cell in
                if self.viewModel.user != nil {
                    self.viewModel.user?.reputation.forEach({ color in
                    cell.backgroundColor = color == 0 ? R.color.basicWhite()! : R.color.brandGreen()!
                    })
                } else {
                    self.reputation.forEach { color in
                        cell.backgroundColor = color == 0 ? R.color.basicWhite()! : R.color.brandGreen()!
                    }
                }
                // item은 모델이 날라오는거 -> 따라서 모델에 컬러가 있어야 겠고 그 컬러는
                // API 통신에서 숫자로 true/false로 저장해두자
                // 여기서는 조건만 달아서 색 변경
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
