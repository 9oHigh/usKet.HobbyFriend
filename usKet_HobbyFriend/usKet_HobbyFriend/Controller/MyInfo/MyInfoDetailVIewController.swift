//
//  MyInfoDetailVIewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class MyInfoDetailViewController : BaseViewController {
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = R.color.basicWhite()!
        return view
    }()
    let withdrawButton = UIButton()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = R.color.basicWhite()!
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    let myinfoView = MyInfoView()
    let specificView = MyInfoSpecificView()
    
    let viewModel = MyInfoViewModel()
    let disposeBag = DisposeBag()
    var isCollapse : Bool = false //흠.. 뷰모델에서 만들어서 해야하나
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "정보 관리"
        navigationController?.navigationBar.titleTextAttributes = [
            .font : UIFont.toTitleM14!,
            .foregroundColor : UIColor(resource: R.color.basicBlack)!
        ]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain , target: self, action: #selector(saveMyInfo))
        
        setConfigure()
        setUI()
        setConstraints()
        bind()
        monitorNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //타이틀
        myinfoView.foldView.titleView.viewModel.user = self.viewModel.user
        myinfoView.foldView.titleView.collectionView.reloadData()
        monitorNetwork()
    }
    
    //하 이렇게 짜기 싫은데.. 뷰로만들어서 괴롭네
    override func setConfigure() {
        
        //delegate for CENTER.x
        scrollView.delegate = self
        
        let user = viewModel.user
        //이미지 + 새싹
        myinfoView.backgroundView.background.image = user?.background == 0 ? R.image.sesacbackground1()! : R.image.sesacbackground2()!
        myinfoView.backgroundView.sesac.image = user?.sesac == 0 ? R.image.sesac_face_1()! : R.image.sesac_face_2()!
        
        //리뷰
        myinfoView.foldView.reviewTextView.text = user!.comment.isEmpty ? "첫 리뷰를 기다리는 중이에요!" : user?.comment[0]
        
        //성별
        switch user?.gender {
        case 0:
            specificView.womanButton.backgroundColor = R.color.brandGreen()!
            specificView.womanButton.setTitleColor(R.color.basicWhite()!, for: .normal)
        case 1:
            specificView.manButton.backgroundColor = R.color.brandGreen()!
            specificView.manButton.setTitleColor(R.color.basicWhite()!, for: .normal)
        default:
            break
        }
        
        //취미
        if user?.hobby != ""{ specificView.hobbyTextField.text = user?.hobby}
        
        //검색허용
        specificView.permitSwitch.isOn = user?.searchable == 0 ? false : true
        
        //연령대
        
        specificView.ageSlider.lowerValueStepIndex = user!.ageMin - 18
        specificView.ageSlider.upperValueStepIndex = user!.ageMax - 19
        specificView.agesLabel.text = "\(user!.ageMin) - \(user!.ageMax)"

        //withrawButton
        withdrawButton.backgroundColor = UIColor(resource: R.color.basicWhite)
        withdrawButton.setTitleColor(UIColor(resource: R.color.basicBlack), for: .normal)
        withdrawButton.setTitle("회원탈퇴", for: .normal)
        withdrawButton.titleLabel?.font = UIFont.toTitleR14
    }
    
    override func setUI() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(myinfoView)
        contentView.addSubview(specificView)
        contentView.addSubview(withdrawButton)
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        myinfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            // 고정높이 MyInfoView.foldview.height = 300
            // 따라서 MyInfoView.bacground.height = 200
            make.height.equalTo(500)
        }
        
        specificView.snp.makeConstraints { make in
            //왜 MyInfoView에는 안되는가
            make.top.equalTo(myinfoView.foldView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.bottom.equalTo(withdrawButton.snp.top)
        }
        
        withdrawButton.snp.makeConstraints { make in
            //왜 SpecificView에는 안되는가
            make.top.equalTo(specificView.agesLabel.snp.bottom).offset(50)
            make.leading.equalTo(0)
            make.width.equalTo(100)
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
    }
    override func bind() {
        
        myinfoView.foldView.flipButton.rx.tap
            .asDriver()
            .drive(){ [weak self] _ in
                self?.isCollapse = !self!.isCollapse
                self?.updateConstraints(isCollapse: self!.isCollapse)
            }
            .disposed(by: disposeBag)
        
        withdrawButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                
                let alertView = self.generateAlertView(inform: "정말로 탈퇴하시겠습니까?", subInform: "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요!")
                
                alertView.okButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe({ [weak self] _ in
                        self?.viewModel.resetUserInfo { status,message in
                            status ? self?.transViewWithAnimation(isNavigation: false, controller: OnboardViewController()) : self?.showToast(message: message!)
                        }
                    })
                    .disposed(by: self.disposeBag)
                
                alertView.cancelButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe { _ in
                        alertView.dismiss(animated: true, completion: nil)
                    }
                    .disposed(by: self.disposeBag)
                
                self.transViewController(nextType: .present, controller: alertView)
            })
            .disposed(by: self.disposeBag)
    }
    @objc
    func saveMyInfo(){
        
        let userDefaults = UserDefaults.standard

        userDefaults.set(specificView.hobbyTextField.text ?? "", forKey: "hobby")
        
        specificView.permitSwitch.isOn ?
        userDefaults.set(1, forKey: "searchable") :userDefaults.set(0, forKey: "searchable")
        
        viewModel.myPageUpdate { [weak self] error in
            guard error == nil else {
                if error != "미가입 회원입니다."{
                    self?.showToast(message: error!)
                } else {
                    self?.view.window?.rootViewController = OnboardViewController()
                    self?.view.window?.makeKeyAndVisible()
                }
                return
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateConstraints(isCollapse : Bool){
        
        isCollapse ? self.foldView() : self.unFoldView()
    }
    
    func foldView(){
        //왜 moreArrow랑 noMoreArrow는 R로 안될까
        myinfoView.foldView.flipButton.setImage(UIImage(named: "moreArrow.svg"), for: .normal)
        
        self.myinfoView.foldView.titleView.snp.updateConstraints{ make in
            make.height.equalTo(0)
        }
        self.myinfoView.foldView.toHideView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        self.myinfoView.foldView.snp.updateConstraints { make in
            make.height.equalTo(60)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func unFoldView(){
        
        myinfoView.foldView.flipButton.setImage(UIImage(named: "noMoreArrow.svg"), for: .normal)
        
        self.myinfoView.foldView.snp.updateConstraints { make in
            make.height.equalTo(320)
        }
        self.myinfoView.foldView.toHideView.snp.updateConstraints { make in
            make.height.equalTo(240)
        }
        self.myinfoView.foldView.titleView.snp.updateConstraints{ make in
            make.height.equalTo(120)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
extension MyInfoDetailViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
   
