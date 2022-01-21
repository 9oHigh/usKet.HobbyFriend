//
//  UIViewController + Extension.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/20.
//

import Foundation
import UIKit



enum NextType {
    case push,present
}

extension UIViewController {
    
    func showToast(message : String, font : UIFont , width: CGFloat, height : CGFloat) {
        
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - width/2, y: view.frame.size.height - 100, width: width, height: height))
        
        //Configure
        toastLabel.backgroundColor = UIColor(resource: R.color.basicBlack)?.withAlphaComponent(0.5)
        toastLabel.textColor = UIColor(resource: R.color.basicWhite)
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        //Animation
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        },
            completion: { Completed in
            toastLabel.removeFromSuperview()
        })
    }
    
    func transViewController(nextType : NextType, controller : UIViewController){

        switch nextType {
            
        case .push:
            let viewcontroller = controller
            controller.navigationItem.backBarButtonItem?.tintColor = .black
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.pushViewController(viewcontroller, animated: true)
            
        case .present:
            let viewcontroller = controller
            self.present(viewcontroller, animated: true, completion: nil)
        }
    }
}

