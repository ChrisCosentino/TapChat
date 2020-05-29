//
//  SearchVC.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-05-23.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameSearchBar: UISearchBar!
    
    var searchResults: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        usernameSearchBar.delegate = self
        
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let uid = UserDefaults.standard.string(forKey: "uid") ?? ""
        print("this is the username: " + username)
        print("uid = " + uid)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        cell.usernameLbl.text = searchResults[indexPath.row].username
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //After the text changes in the search bar, update the search results array
        print(searchText)
        
        let db = Firestore.firestore()
        // Create a reference to the users collection
        let usersRef = db.collection("users")
        
        self.searchResults.removeAll()
        self.tableView.reloadData()
        // Create a query against the collection.
        //This code shows the results from search
        usersRef.whereField("username", isEqualTo: searchText).getDocuments { (snapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    print(document.data())
                    let friend = Friend(data: document.data())
                    if friend.uid != Auth.auth().currentUser?.uid{
                        print(friend.username)
                        print(friend.uid)
                        self.searchResults.append(friend)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let user = searchResults[indexPath.row]
        let friendPicked = searchResults[indexPath.row]
        print(friendPicked.uid)
        //searchUID(other: user)
        

        let current = CurrentUser(username: UserDefaults.standard.string(forKey: "username")!, email: UserDefaults.standard.string(forKey: "email")!, uid: UserDefaults.standard.string(forKey: "uid")!, provider: "")
        createChat(member1: current, member2: friendPicked)
      
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func createChat(member1: CurrentUser, member2: Friend){
        let db = Firestore.firestore()
        var messageUID = ""
        let uid1 = member1.uid
        let uid2 = member2.uid
        
        if uid1 < uid2{
            messageUID = uid1 + uid2
        }else{
            messageUID = uid2 + uid1
        }
        //Checking if document messageID already exists
        let docRef = db.collection("chats").document(messageUID)
        docRef.getDocument { (snapshot, error) in
            if snapshot!.exists{
                //The document already exists in the db, dont create the chat
                print("Already have a conversation")
                
            }else{
                //document doesnt exists in the db
                //This code creates a chat between two people
                //--------------------------------------------
                let chatRef = db.collection("chats")
                chatRef.document(messageUID).setData([
                    "user1": member1.username,
                    "user2": member2.username
                    ])
                
                let conversationRef = db.collection("users").document(UserDefaults.standard.string(forKey: "username")!).collection("conversations").document()
                let currentUsername = UserDefaults.standard.string(forKey: "username")!
                var friend: String = ""
                if currentUsername == member1.username{
                    friend = member2.username
                }else{
                    friend = member1.username
                }
                conversationRef.setData([
                    "messageID": messageUID,
                    "friend": friend
                    ])
                
                let friendRef = db.collection("users").document(friend).collection("conversations").document()
                friendRef.setData([
                    "messageID": messageUID,
                    "friend": currentUsername
                    ])
                //----------------------------------------------
            }
        }
        self.performSegue(withIdentifier: "SEGUE_TO_MESSAGES", sender: self)
    }
}

