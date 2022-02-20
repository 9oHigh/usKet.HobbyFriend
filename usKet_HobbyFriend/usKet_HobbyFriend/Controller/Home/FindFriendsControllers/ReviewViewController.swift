//
//  ReviewView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/20.
//

import UIKit
import Then

class ReviewCell: UITableViewCell {
    
    static let identifier = "ReviewCell"
    
    let reviewLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .toBodyR14
        $0.textColor = R.color.basicBlack()!
        $0.textAlignment = .natural
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ReviewViewController: BaseViewController {
    
    let tableView = UITableView()
    let viewModel = FindFriendsTabViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "새싹 리뷰"
        view.backgroundColor = R.color.basicWhite()!
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = R.color.basicWhite()!
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {
            return UITableViewCell()
        }
        cell.reviewLabel.text = viewModel.reviews[indexPath.row]
        
        return cell
    }
    
}
