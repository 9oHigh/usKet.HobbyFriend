//
//  ChattingViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/20.
//

import UIKit
import RxCocoa
import RxSwift

final class ChattingViewController: BaseViewController {
    
    let chatMenu = ChatMenuView()
    
    let viewModel = ChatViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.otherNick
        
        setConfigure()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    override func setConfigure() {
        // view
        self.hiddenNavBar(false)
        self.tabBarController?.tabBar.isHidden = true
        
        // backToHome
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.letfArrow()!, style: .plain, target: self, action: #selector(backToInitial))
        
        // showMenu
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.more()!, style: .plain, target: self, action: nil)
        
        // menu
        chatMenu.isHidden = false
        
    }
    
    override func setUI() {
        
    }
    
    override func setConstraints() {
        
    }
    
    override func bind() {
        
        navigationItem.rightBarButtonItem!.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                self.setMenu(isHidden: self.chatMenu.isHidden)
            })
            .disposed(by: disposeBag)
    }
    
    private func setMenu(isHidden: Bool) {
        
        if isHidden {
            
            chatMenu.removeFromSuperview()
            chatMenu.isHidden = !chatMenu.isHidden
            
        } else {
            
            view.addSubview(chatMenu)
            
            chatMenu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
            
            UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseIn) {
                
                self.chatMenu.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 100)
                
            } completion: { _ in }
            
            chatMenu.isHidden = !chatMenu.isHidden
        }
    }
    
    @objc
    func backToInitial() {
        guard let navigationController = navigationController else {
            return
        }
        let controllers = navigationController.viewControllers
        self.navigationController?.popToViewController(controllers[0], animated: true)
    }
    
    @objc func showMenu() {
        
    }
}
