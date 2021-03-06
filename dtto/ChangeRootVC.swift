//
//  ChangeRootVC.swift
//  Chain
//
//  Created by Jitae Kim on 10/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum RootVC {
        case login
        case logout
    }
    
    func changeRootVC(vc: RootVC) {
        
        if vc == RootVC.login {
            
            guard let snapshot:UIView = (self.view.window?.snapshotView(afterScreenUpdates: true)) else { return }
            let initialViewController = TabBarController()
            initialViewController.view.addSubview(snapshot)
            
            self.view.window?.rootViewController = initialViewController
            
            UIView.animate(withDuration: 0.2, animations: {()  in
                
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
                }, completion: {
                    (value: Bool) in
                    snapshot.removeFromSuperview()
                    
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.viewControllers.removeAll()
                
            })

        }
        else {
            
            let initialViewController = LoginHome()
            
            let snapshot:UIView = (self.view.window?.snapshotView(afterScreenUpdates: true))!
            initialViewController.view.addSubview(snapshot)
            
            self.view.window?.rootViewController = initialViewController
            
            UIView.animate(withDuration: 0.2, animations: {()  in
                
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
                }, completion: {
                    (value: Bool) in
                    snapshot.removeFromSuperview()
                    
            })

        }
        
    }
    
}
