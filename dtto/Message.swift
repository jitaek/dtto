//
//  Message.swift
//  dtto
//
//  Created by Jitae Kim on 12/12/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: String?
    var toId: String?
    
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    var videoUrl: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? String
        toId = dictionary["toId"] as? String
        
//        imageUrl = dictionary["imageUrl"] as? String
//        imageHeight = dictionary["imageHeight"] as? NSNumber
//        imageWidth = dictionary["imageWidth"] as? NSNumber
//        
//        videoUrl = dictionary["videoUrl"] as? String
    }
}
