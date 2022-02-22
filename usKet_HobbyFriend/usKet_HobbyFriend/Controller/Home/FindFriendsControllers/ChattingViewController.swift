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
    
    let touchView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    let sendButton = UIButton().then {
        
        $0.setImage(R.image.send()!, for: .normal)
        $0.backgroundColor = .clear
        $0.tintColor = R.color.gray7()!
    }
    
    let chatMenu = ChatMenuView()
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let viewModel = ChatViewModel()
    let disposeBag = DisposeBag()
    
    var myToggle: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDatas()
        setConfigure()
        setUI()
        setConstraints()
        bind()
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
        tableView.backgroundColor = R.color.basicWhite()!
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 80
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
        
        view.addSubview(touchView)
    }
    
    override func setConstraints() {
        
        resetMenu()
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
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
        
        chatMenu.reviewButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                self.resetMenu()
                let reviewController = ShowDetailView()
                // 유저 아이디설정
                reviewController.setUpViewController(main: "리뷰 등록", sub: "\(self.viewModel.otherNick)님과의 취미활동은 어떠셨나요?", type: 0, btnTitle: "리뷰 등록하기")
                reviewController.modalPresentationStyle = .overCurrentContext
                self.present(reviewController, animated: true, completion: nil)
                
                reviewController.checkButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe({ _ in
                        // (POST, /queue/rate/{id}) 호출
                        // 성공시 홈으로 이동
                        reviewController.dismiss(animated: true, completion: nil)
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        chatMenu.reportButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                self.resetMenu()
                
                let reviewController = ShowDetailView()
                reviewController.setUpViewController(main: "새싹 신고", sub: "다시는 해당 새싹과 매칭되지 않습니다", type: 1, btnTitle: "신고 하기")
                reviewController.modalPresentationStyle = .overCurrentContext
                
                self.present(reviewController, animated: true, completion: nil)
                
                reviewController.checkButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe({ _ in
                        // (POST, /user/report) 호출
                        // dismiss
                        reviewController.dismiss(animated: true, completion: nil)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        chatMenu.cancelButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                self.resetMenu()
                
                let alertView = self.generateAlertView(inform: "약속을 취소하시겠습니까?", subInform: "약속을 취소하시면 패널티가 부과됩니다")
                alertView.modalPresentationStyle = .overCurrentContext
                
                self.present(alertView, animated: true, completion: nil)
                
                alertView.cancelButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe({ _ in
                        alertView.dismiss(animated: true, completion: nil)
                    })
                    .disposed(by: self.disposeBag)
                
                alertView.okButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe({ _ in
                        // (POST, /queue/dodge) 호출
                        
                        alertView.dismiss(animated: true, completion: nil)
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
    }
    
    func fetchDatas() {
        // view
        viewModel.userCheckIsMatch {  error, toHome in
            guard let error = error else {
                return
            }
            if error == "토큰"{
                DispatchQueue.main.async {
                    self.viewModel.userCheckIsMatch { _, _ in }
                }
            } else {
                self.showToast(message: error)
            }
            
            guard toHome != nil else {
                return
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc
    private func setMenu() {
        
        UIView.animate(withDuration: 0.5, delay: 0.01, options: .transitionCurlDown) {
            let height = self.navigationController?.navigationBar.frame.maxY
            self.chatMenu.frame = CGRect(x: 0, y: height!, width: UIScreen.main.bounds.width, height: 100)
            
        } completion: { _ in
            self.touchView.frame = CGRect(x: 0, y: self.chatMenu.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    private func resetMenu() {
        
        let height = self.navigationController?.navigationBar.frame.maxY
        
        self.touchView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height!)
        
        UIView.animate(withDuration: 0.5, delay: 0.01, options: .transitionCurlUp) {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView().then {
            $0.backgroundColor = R.color.basicWhite()!
        }
        
        let imageView = UIImageView().then {
            $0.image = R.image.bell()!
            $0.tintColor = R.color.basicBlack()!
        }
        
        let matchLabel = UILabel().then {
            $0.font = .toTitleM14
            $0.textColor = R.color.basicBlack()!
            $0.textAlignment = .center
            $0.text = "달콩님과 매칭되었습니다"
        }
        
        let informLabel = UILabel().then {
            $0.textColor = R.color.gray7()!
            $0.textAlignment = .center
            $0.font = .toTitleR14
            $0.text = "채팅을 통해 약속을 정해보세요!"
        }
        
        headerView.addSubview(matchLabel)
        headerView.addSubview(informLabel)
        matchLabel.addSubview(imageView)
        
        matchLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(imageView.snp.height)
            make.leading.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        
        informLabel.snp.makeConstraints { make in
            make.top.equalTo(matchLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        return headerView
    }
}
