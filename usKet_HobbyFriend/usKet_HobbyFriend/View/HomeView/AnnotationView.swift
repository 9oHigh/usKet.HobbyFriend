//
//  AnnotationView.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/09.
//

import UIKit
import MapKit

final class AnnotationView: MKAnnotationView {
    
    static let identifier = "AnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
