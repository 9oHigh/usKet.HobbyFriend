//
//  HomeTabViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/23.
//

import UIKit
import Tabman
import Pageboy

final class ShopViewController: BaseViewController {
    
    var myImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
    }
    
    override func setConfigure() {
        
        title = "새싹샵"
        view.backgroundColor = UIColor(resource: R.color.basicWhite)
        
    }
    
    override func setUI() {
        
    }
    
    override func setConstraints() {
        
    }
    
    override func bind() {
        
    }
}
