//
//  Notifications.swift
//  dtto
//
//  Created by Jitae Kim on 12/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class NotificationsCell: BaseTableViewCell {
    
    let profileImageView = RoundImageView(image: #imageLiteral(resourceName: "profile"))
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    let arrowImage = UIImageView(image: #imageLiteral(resourceName: "arrow"))
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImageView)
        addSubview(notificationLabel)
        addSubview(arrowImage)
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 15, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        profileImageView.anchorCenterYToSuperview()
        
        notificationLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        arrowImage.anchor(top: nil, leading: notificationLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 25, heightConstant: 25)
        arrowImage.anchorCenterYToSuperview()
    }
}

//class NotificationsCell: BaseCollectionViewCell {
//    
//    let profile = RoundImageView()
//    let desc = UILabel()
//    
//    override func setupViews() {
//        super.setupViews()
//        profile.contentMode = .scaleAspectFill
//        profile.image = #imageLiteral(resourceName: "profile")
////        desc.text = "This person related to you."
//        desc.adjustsFontSizeToFitWidth = true
//        desc.sizeToFit()
//        addSubview(desc)
//        addSubview(profile)
//        
//        profile.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
//        profile.anchorCenterYToSuperview()
//
//        desc.anchor(top: nil, leading: profile.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
//        desc.anchorCenterYToSuperview()
//    }
//    
//    
//}

