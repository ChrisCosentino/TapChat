//
//  MessageListVC.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-05-23.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase

class MessageListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var conversations: [Conversation] = []
  
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.checkIfUserIsSignedIn()
       
        let uidRef = db.collection("uids")
        let userRef = db.collection("users")
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        var current: CurrentUser!
//        uidRef.document(userID).getDocument { (snapshot, error) in
//            if let snapshot = snapshot, snapshot.exists {
//                let dataDescription = snapshot.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        userRef.whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
            
            if let err = error{
                print("Error getting documents: \(err)")
            }else{
                    for document in snapshot!.documents{
                        current = CurrentUser(data: document.data())
                        UserDefaults.standard.set(current.username, forKey: "username")
                        UserDefaults.standard.set(current.email, forKey: "email")
                        UserDefaults.standard.set(current.uid, forKey: "uid")
                        let conversationRef = self.db.collection("users").document(current.username).collection("conversations")
                                conversationRef.addSnapshotListener { (snapshot, err) in
                                    self.conversations.removeAll()
                                    if let error = err{
                                        print("Error getting documents: \(err)")
                                    }else{
                                        for document in snapshot!.documents{
                                            print("data: \(document.data())")
                                            self.searchConvo(messageID: document.data())
                                        }
                                    }
                            }
                    }
            }
        }
        tableView.reloadData()
    }
    
    private func checkIfUserIsSignedIn() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                // user is not signed in
                // go to login controller
               self.signOut()
            }
        }
    }
    
    
    func searchConvo(messageID: [String: Any]) {
        
        let convos = Conversation(data: messageID)
        print("Convo ID: " + convos.messageId)
        conversations.append(convos)
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if conversations.count == 0{
            self.tableView.setEmptyMessage("You dont have any conversations yet. To start a new conversation, press the compose button on the top right of the screen")
        }else{
            self.tableView.restore()
        }
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageListCell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
        
        cell.username.text = self.conversations[indexPath.row].friend
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SEGUE_SHOW_CHAT", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SEGUE_SHOW_CHAT" {
            let indexPaths=self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destination as! ChatVC
            
            vc.messageID = self.conversations[indexPath.row].messageId
            vc.friend = self.conversations[indexPath.row].friend
        }
    }

    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        self.signOut()
    }
    
    private func signOut(){
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "SEGUE_TO_LOGIN", sender: self)
        } catch let err {
            print(err)
        }
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
