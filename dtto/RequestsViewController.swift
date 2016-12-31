//
//  RequestsViewController.swift
//  dtto
//
//  Created by Jitae Kim on 12/22/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

enum RequestAction {
    case accept
    case decline
}

protocol RequestsDelegate : class {
    func handleRequest(row: Int, action: RequestAction)
}

class RequestsViewController: UIViewController, RequestsDelegate {

    var requests = [Notification]()
//    var requestsRef: FIRDatabaseReference! = FIREBASE_REF.child("requests/uid1") {
//        didSet {
//            // get requests
//            getRequests()
//        }
//    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = 70
        tv.allowsSelection = false
        return tv
    }()
    
    init(requests: [Notification]) {
        super.init(nibName: nil, bundle: nil)
        self.requests = requests
        print(self.requests.count)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }
    
    private func setupViews() {
        
        self.title = "Chat Requests"
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableView.register(UINib(nibName: "RequestsViewCell", bundle: nil), forCellReuseIdentifier: "RequestsViewCell")
        
    }
    
//    private func getRequests() {
//        requestsRef.observeSingleEvent(of: .childAdded, with: { snapshot in
//            
//            guard let userRequests = snapshot.value as? Dictionary<String, AnyObject> else { return }
//            
//            let request = Notification()
//            
//            
//            
//            
//        })
//        
//    }
    
    func chatToDictionary(chat: Chat) -> [String : String]? {
        
        var chatDictionary = [String : String]()
        
        guard let name = chat.name, let uid = chat.senderID, let questionID = chat.questionID else {
            print("User dictionary is nil. something went wrong")
            return nil
        }
        
        chatDictionary.updateValue(name, forKey: "name")
        chatDictionary.updateValue(uid, forKey: "senderID")
        chatDictionary.updateValue(questionID, forKey: "questionID")
        
        if let profile = chat.profileImageURL {
            chatDictionary.updateValue(profile, forKey: "profileImageURL")
        }
        
        return chatDictionary
        
    }
    
    func handleRequest(row: Int, action: RequestAction) {
        
        let request = requests[row]
        
        guard let userID = FIRAuth.auth()?.currentUser?.uid, let friendID = request.userID, let friendName = request.name, let questionID = request.questionID else { return }
        
        let userName = FIRAuth.auth()?.currentUser?.displayName ?? "Anonymous"
        switch action {
            
        case .accept:
            
            print("accepted chat request!")
            
            // Create the chat room with these two users. This path will later be updated to show the last message of this chat room.
            
            let chatsRef = FIREBASE_REF.child("chats")
            let autoID = chatsRef.childByAutoId().key   // Update both userChats with this key.
            let users = [userID : userName, friendID : friendName]
            let baseChat: [String : Any] = ["users" : users, "questionID" : questionID]
            chatsRef.updateChildValues([autoID : baseChat])

            let dataRequest = FirebaseService.dataRequest
            
            // update chat list for both users, with the chat ID
            dataRequest.startChat(ref: FIREBASE_REF.child("users/\(userID)/chats/\(autoID)"))
            dataRequest.startChat(ref: FIREBASE_REF.child("users/\(friendID)/chats/\(autoID)"))
        
            // increment number of ongoing chats for question.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("questions/\(questionID)/chatCount"))
            
            // increment user's and friend's number of ongoing chats.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(userID)/ongoingChatCount"))
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(friendID)/ongoingChatCount"))
            
            // increment user's and friend's number of total chats.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(userID)/totalChatCount"))
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(friendID)/totalChatCount"))

        case .decline:
            print("declined chat request!")
            break
        }
        
    }


}

extension RequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsViewCell") as! RequestsViewCell
        
        let request = requests[indexPath.row]
        
        cell.profile.image = #imageLiteral(resourceName: "profile")
        cell.name.text = request.name
        cell.displayName.text = request.name
        
        cell.requestsDelegate = self
        
        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        
        return cell
        
    }
    
}