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
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class ReviewViewController: BaseViewController {
    
    let tableView = UITableView()
    let data = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "새싹 리뷰"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        
    }
    
    override func setConfigure() {
        
        tableView.backgroundColor = R.color.basicWhite()!
        tableView.separatorStyle = .none
        
    }
 
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
