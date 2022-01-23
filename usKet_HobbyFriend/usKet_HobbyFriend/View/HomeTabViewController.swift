//
//  HomeTabViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/23.
//

import UIKit

class HomeTabViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
    }
    
    func setConfigure(){
        
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
//        tabBarItem.image = UIImage(resource: R.image.tabHome)!
//        tabBarItem.title = "홈"
    }
    
    func setUI(){
        
    }
    
    func setConstraints(){
        
    }
    
    func bind(){
        
    }
}
