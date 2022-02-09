//
//  AnnotationView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/09.
//

import UIKit
import MapKit

enum SeSACImageType: Int {
    case sesac0 = 0
    case sesac1 = 1
    case sesac2 = 2
    case sesac3 = 3
    case sesac4 = 4
}

final class AnnotationView: MKAnnotationView {
    
    static let identifier = "AnnotationView"
    
    // Default imageType
    let imageType = SeSACImageType.sesac0
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
