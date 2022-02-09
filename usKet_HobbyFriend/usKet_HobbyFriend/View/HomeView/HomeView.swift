//
//  HomeView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/08.
//

import UIKit
import MapKit
import Then

final class HomeView: UIView {
    
    // mapView
    let mapView = MKMapView()
    
    // Buttons
    let allButton  = UIButton().then {
        
        $0.setTitle("전체", for: .normal)
        $0.titleLabel?.font = .toTitleR14
        $0.setTitleColor(R.color.basicBlack(), for: .normal)
        $0.backgroundColor = R.color.brandGreen()!  
        $0.addTarget(self, action: #selector(coloredButton(_:)), for: .touchUpInside)
    }
    
    let manButton = UIButton().then {
        
        $0.backgroundColor = R.color.basicWhite()
        $0.setTitle("남자", for: .normal)
        $0.setTitleColor(R.color.basicBlack(), for: .normal)
        $0.titleLabel?.font = .toTitleR14
        $0.addTarget(self, action: #selector(coloredButton(_:)), for: .touchUpInside)
    }
    
    let womanButton = UIButton().then {
        
        $0.backgroundColor = R.color.basicWhite()
        $0.setTitle("여자", for: .normal)
        $0.setTitleColor(R.color.basicBlack(), for: .normal)
        $0.titleLabel?.font = .toTitleR14
        $0.addTarget(self, action: #selector(coloredButton(_:)), for: .touchUpInside)
    }
    
    lazy var backView = UIView().then {
        
        $0.backgroundColor = R.color.basicWhite()
        $0.layer.cornerRadius = 10
        
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowColor = R.color.basicBlack()!.cgColor
        $0.layer.shadowOffset = CGSize(width: 5, height: -3)
        $0.layer.shadowRadius = 10
        
        $0.layer.masksToBounds = false
    }
    
    lazy var genderStackView = UIStackView().then {
        
        $0.addArrangedSubview(allButton)
        $0.addArrangedSubview(manButton)
        $0.addArrangedSubview(womanButton)
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 0
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let gpsButton = UIButton().then {
        
        $0.setImage(R.image.place(), for: .normal)
        $0.backgroundColor = R.color.basicWhite()
        $0.tintColor = R.color.basicBlack()
        $0.layer.cornerRadius = 10
        
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 5, height: -3)
        $0.layer.shadowRadius = 10
    }
    
    let navigatorButton = UIButton().then {
        $0.backgroundColor = R.color.basicBlack()!
        $0.setImage(R.image.searchHobby()!, for: .normal)
        $0.backgroundColor = .clear
    }
    
    // Center Pin
    let centerPinView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.image = R.image.annotation()!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        addSubview(mapView)
        
        mapView.addSubview(backView)
        mapView.addSubview(gpsButton)
        mapView.addSubview(navigatorButton)
        mapView.addSubview(centerPinView)
        
        backView.addSubview(genderStackView)
    }
    
    private func setConstraints() {
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        centerPinView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(144)
            make.width.equalTo(48)
            make.bottom.equalTo(gpsButton.snp.top).offset(-10)
        }
        
        genderStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gpsButton.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom)
            make.height.width.equalTo(48)
            make.leading.equalToSuperview().inset(20)
        }
        
        navigatorButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.trailing.equalTo(-20)
            make.height.width.equalTo(64)
        }
    }
    
    @objc
    private func coloredButton(_ sender: UIButton) {
        [allButton, manButton, womanButton].forEach { isSelected in
            
            if isSelected == sender {
                isSelected.backgroundColor = R.color.brandGreen()!
                isSelected.setTitleColor(R.color.basicWhite()!, for: .normal)
            } else {
                isSelected.backgroundColor = R.color.basicWhite()!
                isSelected.setTitleColor(R.color.basicBlack()!, for: .normal)
            }
        }
    }
    
    func changeImage(_ toType: String) {
        switch toType {
        case "searchHobby":
            self.navigatorButton.setImage(R.image.searchHobby()!, for: .normal)
        case "readyMatching":
            self.navigatorButton.setImage(R.image.readyMatching()!, for: .normal)
        case "matched":
            self.navigatorButton.setImage(R.image.matched()!, for: .normal)
        default:
            break
        }
    }
}
