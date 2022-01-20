//
//  OnboardingViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import Foundation
import UIKit
import SnapKit

class OnboardViewController : UIViewController {
    
    lazy var locationView : UIView = {
        //반환할 뷰
        let view = UIView()
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        let locationlabel = UILabel()
        locationlabel.numberOfLines = 0
        locationlabel.tintColor = .black
        locationlabel.text = "위치 기반으로 빠르게\n주위 친구를 확인"
        locationlabel.toColored(text: locationlabel.text!, target: "위치 기반", color: UIColor(resource: R.color.brandGreen)!)
        locationlabel.textAlignment = .center
        locationlabel.font = UIFont.DisplayR20
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.onboardFirst()
        
        view.addSubview(locationlabel)
        view.addSubview(imageView)
        
        locationlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.3)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var hobbyView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        let hobbylabel = UILabel()
        hobbylabel.numberOfLines = 0
        hobbylabel.tintColor = .black
        hobbylabel.text = "관심사가 같은 친구를\n찾을 수 있어요"
        hobbylabel.toColored(text: hobbylabel.text!, target: "관심사가 같은 친구", color: UIColor(resource: R.color.brandGreen)!)
        hobbylabel.textAlignment = .center
        hobbylabel.font = UIFont.DisplayR20
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.onboardSecond()
        
        view.addSubview(hobbylabel)
        view.addSubview(imageView)
        
        hobbylabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.3)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var friendView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        let friendlabel = UILabel()
        friendlabel.numberOfLines = 0
        friendlabel.tintColor = .black
        friendlabel.text = "Welcome to SeSAC Friends"
        friendlabel.toColored(text: friendlabel.text!, target: "SeSAC Friends", color: UIColor(resource: R.color.brandGreen)!)
        friendlabel.textAlignment = .center
        friendlabel.font = UIFont.DisplayR20
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.onboardThird()
        
        view.addSubview(friendlabel)
        view.addSubview(imageView)
        
        friendlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.3)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        return view
    }()
    
    //첫번째, 두번째 그리고 세번째 뷰를 담는 배열
    lazy var onboardViews = [locationView,hobbyView,friendView]
    
    lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false //페이지로 만들기 위해서
        scrollView.isPagingEnabled = true // To Page scroll
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(onboardViews.count), height: view.frame.height)
        
        //분리된 뷰컨트롤러라기 보다는 가로가 긴 뷰컨을 나누어서 보여주기 위한 것
        for item in 0...onboardViews.count - 1 {
            scrollView.addSubview(onboardViews[item])
            onboardViews[item].frame = CGRect(x: view.frame.width * CGFloat(item), y: 0, width: view.frame.width, height: view.frame.height)
        }
        
        scrollView.delegate = self
        
        return scrollView
    }()
    
    lazy var pageControl : UIPageControl = {
        
        let pageControl = UIPageControl()
        pageControl.numberOfPages = onboardViews.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(resource: R.color.gray3)
        pageControl.currentPageIndicatorTintColor = UIColor(resource: R.color.gray7)
        
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        
        return pageControl
    }()
    
    lazy var startButton : UIButton = {
        
       let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(resource: R.color.brandGreen)
        button.tintColor = UIColor(resource: R.color.basicWhite)
        button.titleLabel?.font = R.font.notoSansKRMedium(size: 14)
        button.setTitle("시작하기", for: .normal)
        
        button.addTarget(self, action: #selector(toLoginPage(_:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(startButton)
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-50)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-30)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    @objc
    func pageControlTapHandler(sender: UIPageControl){
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
    @objc
    func toLoginPage(_ sender : UIButton){
        
        let loginVC = CertificationViewController()
        
        UIView.transition(with: self.view.window!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.view.window?.rootViewController = UINavigationController(rootViewController: loginVC)
            self.view.window?.makeKeyAndVisible()
        }, completion: nil)
    }
}
extension OnboardViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //스크롤 할때 해당 페이지의 페이지컨트롤 표시하기 위해
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

extension UIScrollView {
    //스크롤 할 수 있게 만들어주는 메서드
    func scrollTo(horizontalPage: Int? = 0, verticalPage: Int? = 0,animated: Bool? = true){
        
        var frame : CGRect = self.frame
        frame.origin.x = frame.size.width * CGFloat(horizontalPage ?? 0)
        frame.origin.y = frame.size.height * CGFloat(verticalPage ?? 0)
        
        self.scrollRectToVisible(frame, animated: animated ?? true)
    }
}
