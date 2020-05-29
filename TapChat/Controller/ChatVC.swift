//
//  ChatVC.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-07-16.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writtenMessage: UITextField!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sendBtn: UIButton!
    
    var messages: [Message] = []
    var messageID: String = ""
    var friend: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
         writtenMessage.delegate = self
        self.title = friend
        // Do any additional setup after loading the view.
    
        self.sendBtn.isUserInteractionEnabled = false
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        //Scroll to bottom of chat
//        let indexPath = NSIndexPath(item: messages.count - 1 , section: 0)
//        tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        
        let db = Firestore.firestore()
        let conversationRef = db.collection("chats").document(messageID).collection("log").order(by: "time", descending: false)
        conversationRef.addSnapshotListener { (snapshot, err) in
            self.messages.removeAll()
            if let error = err{
                print("Error getting documents: \(err)")
            }else{
                for document in snapshot!.documents{
                    print("data: \(document.data())")
                    
                    let m = Message(data: document.data())
                    
                    self.messages.append(m)
                    self.tableView.reloadData()
                }
            }
        }
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        writtenMessage.leftView = indentView
        writtenMessage.leftViewMode = .always
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if writtenMessage.text == "" || writtenMessage.text == " "{
            self.sendBtn.isUserInteractionEnabled = false
            self.sendBtn.image
        }else{
            
            self.sendBtn.isUserInteractionEnabled = true
        }
        return true
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            self.scrollView.contentInset = .zero
        } else {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 5, right: 0)
        }
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        
        cell.senderLbl.text = messages[indexPath.row].sender
        cell.messageLbl.text = messages[indexPath.row].message
        let timeSent = messages[indexPath.row].time.dateValue()
        cell.timeLbl.text = displayTime(currentTime: timeSent)
        
        if messages[indexPath.row].sender == friend{
            cell.messageLbl.backgroundColor = .lightGray
            cell.messageLbl.textColor = .black
        }
        return cell
    }

    @IBAction func sendBtnPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let m = Message(message: writtenMessage.text!, sender: UserDefaults.standard.string(forKey: "username")!, time: Timestamp.init())
        
        let docData: [String: Any] = [
            "message": m.message,
            "sender": m.sender,
            "time": m.time
        ]
        
        db.collection("chats").document(messageID).collection("log").document().setData(docData){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        self.writtenMessage.text = ""
        self.writtenMessage.resignFirstResponder()
    }
}

extension ChatVC{
    func displayTime(currentTime: Date) -> String{
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        
        // get the date time String from the date object
        return formatter.string(from: currentTime) // October 8, 2016 at 10:48:53 PM
    }
}



