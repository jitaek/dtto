//
//  ChatSettings.swift
//  dtto
//
//  Created by Jitae Kim on 12/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ChatSettings: UIViewController {

    let chat: Chat
    let friendID: String
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedRowHeight = 50
        tableView.estimatedSectionHeaderHeight = 20
        
        tableView.register(ProfileImageCell.self, forCellReuseIdentifier: "ProfileImageCell")
        tableView.register(ToggleCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(DestructiveCell.self, forCellReuseIdentifier: "DestructiveCell")
        
        return tableView
    }()
    
    init(chat: Chat, friendID: String) {
        self.chat = chat
        self.friendID = friendID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        
        title = "Chat Settings"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func confirmAlert(type: DestructiveRow) {
        
        var title = ""
        var message = ""
        var deleteTitle = ""
        
        switch type {
        case .delete:
            title = "Remove Chat"
            message = "Remove this chat and all messages?"
            deleteTitle = "Remove"
        case .block:
            title = "Block \(chat.getFriendID())?"
            message = "They will not be able to send you requests."
            deleteTitle = "Remove"
        case .report:
            title = "Report \(chat.getFriendID())?"
            message = "Report this user?"
            deleteTitle = "Remove"
            
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.view.tintColor = Color.darkNavy
        
        let deleteAction = UIAlertAction(title: deleteTitle, style: .destructive, handler: { action in
            switch type {
            case .delete:
                self.deleteChat()
            case .block:
                self.blockUser()
            case .report:
                self.reportUser()
            }
        })
        
        ac.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
            ac.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: {
            ac.view.tintColor = Color.darkNavy
        })

    }

    func deleteChat() {
        
        // present alert.
        
        guard let userID = defaults.getUID() else { return }
        let chatID = chat.getChatID()
        // remove from user's chat list
        let userChatsRef = FIREBASE_REF.child("users").child(userID).child("chats").child(chatID)
        userChatsRef.removeValue()
        
        // update chat room, indicating that this user has deleted. If both users delete, then delete the chat room.
        let chatRef = FIREBASE_REF.child("chats").child(chatID)
        chatRef.child("deleted").observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                // other user already deleted
                chatRef.removeValue()
            }
            else {
                chatRef.child("deleted").setValue(true)
            }
        })
        
    }
    
    func blockUser() {
        
    }
    
    func reportUser() {
        
    }
}

extension ChatSettings: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case profile
        case notifications
        case block
    }
    
    enum DestructiveRow: Int {
        case delete
        case block
        case report
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .block:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell
            cell.profileImageView.loadProfileImage(friendID)
            return cell
        case .notifications:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell") as! ToggleCell
            return cell
        case .block:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestructiveCell") as! DestructiveCell
            
            guard let row = DestructiveRow(rawValue: indexPath.row) else { return cell }
            switch row {
            case .delete:
                cell.titleLabel.text = "Delete"
            case .block:
                cell.titleLabel.text = "Block"
            case .report:
                cell.titleLabel.text = "Report"
            }
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        guard let section = Section(rawValue: indexPath.section) else { return true }
        
        switch section {
        case .block:
            return true
        default:
            return false
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .profile:
            let profileVC = ProfileViewController(userID: friendID)
            navigationController?.pushViewController(profileVC, animated: true)
        case .block:
            guard let row = DestructiveRow(rawValue: indexPath.row) else { return }
            switch row {
            case .delete:
                confirmAlert(type: row)
            case .block:
                break
            case .report:
                break
            }
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
 
    }
}
