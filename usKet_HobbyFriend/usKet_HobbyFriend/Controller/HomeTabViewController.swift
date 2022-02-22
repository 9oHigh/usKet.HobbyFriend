//
//  HomeViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

import UIKit

final class HomeTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = R.color.basicWhite()!
        tabBar.tintColor = UIColor(resource: R.color.brandGreen)
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let home = HomeViewController()
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(resource: R.image.tabHome), tag: 1)
        home.tabBarItem = homeTabBarItem
 
        let shop = ShopViewController()
        let shopTabBarItem = UITabBarItem(title: "새싹샵", image: UIImage(resource: R.image.tabGift), tag: 2)
        shop.tabBarItem = shopTabBarItem
        
        let myinfo = MyInfoViewController()
        let myinfoTabBarItem = UITabBarItem(title: "내정보", image: UIImage(resource: R.image.tabPerson), tag: 4)
        myinfo.tabBarItem = myinfoTabBarItem
        
        self.viewControllers = [UINavigationController(rootViewController: home), shop, UINavigationController(rootViewController: myinfo)]
    }
}
