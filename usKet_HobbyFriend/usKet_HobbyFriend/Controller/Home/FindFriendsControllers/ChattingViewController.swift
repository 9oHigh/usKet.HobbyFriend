//
//  ChattingViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/20.
//

import UIKit
import RxCocoa
import RxSwift
import Then

final class ChattingViewController: BaseViewController {
    
    let messageTextView = UITextView().then {
        
        $0.backgroundColor = R.color.gray2()!
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.sizeToFit()
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 45)
        $0.layer.cornerRadius = 10
        $0.font = .toBodyR14
    }
    
    let sendButton = UIButton().then {
        
        $0.setImage(R.image.send()!, for: .normal)
        $0.backgroundColor = .clear
        $0.tintColor = R.color.gray7()!
    }
    
    let chatMenu = ChatMenuView()
    let tableView = UITableView()
    
    let viewModel = ChatViewModel()
    let disposeBag = DisposeBag()
    
    var myToggle: Bool = true
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        resetMenu()
    }
    
    override func setConfigure() {
        // view
        viewModel.otherNick = "바보"
        title = viewModel.otherNick
        self.hiddenNavBar(false)
        self.tabBarController?.tabBar.isHidden = true
        self.hideKeyboardWhenTappedAround()
        
        // tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChattingViewMyCell.self, forCellReuseIdentifier: ChattingViewMyCell.identifier)
        tableView.register(ChattingViewYourCell.self, forCellReuseIdentifier: ChattingViewYourCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        // backToHome
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.letfArrow()!, style: .plain, target: self, action: #selector(backToInitial))
        
        // showMenu
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.more()!, style: .plain, target: self, action: #selector(setMenu))
        
        // messageView
        messageTextView.delegate = self
    }
    
    override func setUI() {
        
        view.addSubview(tableView)
        view.addSubview(chatMenu)
        view.addSubview(messageTextView)
        messageTextView.addSubview(sendButton)
    }
    
    override func setConstraints() {
        
        resetMenu()
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(messageTextView.snp.top).offset(-5)
            
        }
        
        messageTextView.snp.makeConstraints { make in
            
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-30)
        }
        
        sendButton.snp.makeConstraints { make in
            // 후...위치 조정이 왜 안될까..
            make.leading.equalTo(self.view.frame.width - 60)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
    }
    
    override func bind() {
        
    }
    
    @objc
    private func setMenu() {
        
        UIView.animate(withDuration: 0.5, delay: 0.01, options: .transitionCurlDown) {
            let height = self.navigationController?.navigationBar.frame.maxY
            self.chatMenu.frame = CGRect(x: 0, y: height!, width: UIScreen.main.bounds.width, height: 100)
            
        } completion: { _ in }
    }
    
    private func resetMenu() {
        
        UIView.animate(withDuration: 0.5, delay: 0.01, options: .transitionCurlUp) {
            let height = self.navigationController?.navigationBar.frame.maxY
            self.chatMenu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height!)
            
        } completion: { _ in }
    }
    
    @objc
    func backToInitial() {
        
        guard let navigationController = navigationController else {
            return
        }
        
        let controllers = navigationController.viewControllers
        self.navigationController?.popToViewController(controllers[0], animated: true)
    }
}
extension ChattingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        resetMenu()
        if textView.text == "메세지를 입력하세요" {
            textView.text = nil
            textView.textColor = R.color.basicBlack()!
            sendButton.setImage(R.image.sendfill()!, for: .normal)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "메세지를 입력하세요"
            textView.textColor = R.color.gray4()!
            sendButton.setImage(R.image.send()!, for: .normal)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sendButton.setImage(R.image.sendfill()!, for: .normal)
        } else {
            sendButton.setImage(R.image.send()!, for: .normal)
        }
    }
}
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if myToggle {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingViewMyCell.identifier, for: indexPath) as? ChattingViewMyCell else {
                return UITableViewCell()
            }
            cell.messageBox.text = "바보는 멍청이고 멍청이는 바보야,바보는 멍청이고 멍청이는 바보야,바보는 멍청이고 멍청이는 바보야"
            
            cell.date.text = "12.01"
            myToggle.toggle()
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingViewYourCell.identifier, for: indexPath) as? ChattingViewYourCell else {
                return UITableViewCell()
            }
            cell.messageBox.text = "홀라때 홀라때 홀라때 홀라때 홀라때 홀라때 홀라때 홀라때 홀라때 홀라때"
            
            cell.date.text = "12.01"
            myToggle.toggle()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resetMenu()
    }
}
